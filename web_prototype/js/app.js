/**
 * NeuroTask Main Interactive Controller
 * Connects UI, State, DAG Engine, Audio and Voice interactions across 11 screens.
 */

let activeTask = null;
let zenTimerInterval = null;
let zenSecondsElapsed = 0;
let isZenTimerRunning = true;
let isLowEnergyActive = false;
let isListening = false;
let recognitionInstance = null;
let currentScreenId = 'screen-splash';
let currentOnboardingIndex = 0;

const onboardingData = [
  {
    icon: '🎙️',
    title: 'Volcá tus ideas libremente',
    desc: 'Hacé un Brain Dump por texto o voz sin preocuparte por fechas, categorías o prioridades.'
  },
  {
    icon: '🌲',
    title: 'El sistema descompone y ordena',
    desc: 'NeuroTask convierte tu lista en micro-tareas de 15 min y genera una secuencia clara sin sobrecarga.'
  },
  {
    icon: '🎯',
    title: 'Una sola tarea a la vez',
    desc: 'Enfocate exclusivamente en la micro-tarea actual. Si te trabás, el Rescate Cognitivo te ayuda.'
  }
];

document.addEventListener('DOMContentLoaded', () => {
  initSpeechRecognition();
  updateClock();
  setInterval(updateClock, 10000);

  // Auto transition from Splash to Onboarding after 2.5s
  setTimeout(() => {
    if (currentScreenId === 'screen-splash') {
      goToOnboarding();
    }
  }, 2500);
});

function updateClock() {
  const clockEl = document.getElementById('status-clock');
  if (clockEl) {
    const now = new Date();
    clockEl.innerText = now.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });
  }
}

/**
 * Navigation & Screen Controller
 */
function switchScreen(fromId, toId) {
  const fromEl = document.getElementById(fromId);
  const toEl = document.getElementById(toId);
  
  if (fromEl) fromEl.classList.add('hidden');
  if (toEl) {
    toEl.classList.remove('hidden');
    toEl.classList.add('screen-active');
  }
}

function goToOnboarding() {
  switchScreen(currentScreenId, 'screen-onboarding');
  currentScreenId = 'screen-onboarding';
}

function nextOnboardingSlide() {
  if (window.neuroAudio) window.neuroAudio.playSoftTap();
  if (currentOnboardingIndex < onboardingData.length - 1) {
    currentOnboardingIndex++;
    updateOnboardingUI();
  } else {
    goToAuth();
  }
}

function updateOnboardingUI() {
  const slide = onboardingData[currentOnboardingIndex];
  document.getElementById('ob-icon-card').innerText = slide.icon;
  document.getElementById('ob-title').innerText = slide.title;
  document.getElementById('ob-desc').innerText = slide.desc;
  
  [0, 1, 2].forEach(i => {
    const dot = document.getElementById(`dot-${i}`);
    if (dot) {
      if (i === currentOnboardingIndex) {
        dot.className = "w-6 h-2 rounded-full bg-indigo-600 transition-all";
      } else {
        dot.className = "w-2 h-2 rounded-full bg-slate-300 transition-all";
      }
    }
  });

  if (currentOnboardingIndex === onboardingData.length - 1) {
    document.getElementById('ob-btn-text').innerText = "Comenzar";
  } else {
    document.getElementById('ob-btn-text').innerText = "Siguiente";
  }
}

function goToAuth() {
  if (window.neuroAudio) window.neuroAudio.playSoftTap();
  switchScreen(currentScreenId, 'screen-auth');
  currentScreenId = 'screen-auth';
}

function setAuthTab(isLogin) {
  if (window.neuroAudio) window.neuroAudio.playSoftTap();
  const loginBtn = document.getElementById('tab-login');
  const regBtn = document.getElementById('tab-register');
  if (isLogin) {
    loginBtn.className = "flex-1 py-2 rounded-lg bg-white text-indigo-600 shadow-sm";
    regBtn.className = "flex-1 py-2 rounded-lg text-slate-500";
  } else {
    regBtn.className = "flex-1 py-2 rounded-lg bg-white text-indigo-600 shadow-sm";
    loginBtn.className = "flex-1 py-2 rounded-lg text-slate-500";
  }
}

function goToWelcome() {
  if (window.neuroAudio) window.neuroAudio.playSoftTap();
  switchScreen(currentScreenId, 'screen-welcome');
  currentScreenId = 'screen-welcome';
}

function goToProfile() {
  if (window.neuroAudio) window.neuroAudio.playSoftTap();
  switchScreen(currentScreenId, 'screen-profile');
  currentScreenId = 'screen-profile';
}

function goToSettings() {
  if (window.neuroAudio) window.neuroAudio.playSoftTap();
  switchScreen(currentScreenId, 'screen-settings');
  currentScreenId = 'screen-settings';
}

function enterFromWelcome(skipToFocus = false) {
  if (window.neuroAudio) window.neuroAudio.playSoftTap();
  if (skipToFocus && activeTask) {
    switchScreen(currentScreenId, 'screen-focus');
    currentScreenId = 'screen-focus';
  } else {
    switchScreen(currentScreenId, 'screen-brain-dump');
    currentScreenId = 'screen-brain-dump';
  }
}

function resetToBeginning() {
  if (window.neuroAudio) window.neuroAudio.playSoftTap();
  currentOnboardingIndex = 0;
  updateOnboardingUI();
  switchScreen(currentScreenId, 'screen-splash');
  currentScreenId = 'screen-splash';
  setTimeout(() => {
    if (currentScreenId === 'screen-splash') {
      goToOnboarding();
    }
  }, 2500);
}

/**
 * Speech recognition support (Web Speech API + Fallback)
 */
function initSpeechRecognition() {
  const SpeechRecognition = window.SpeechRecognition || window.webkitSpeechRecognition;
  if (SpeechRecognition) {
    recognitionInstance = new SpeechRecognition();
    recognitionInstance.continuous = false;
    recognitionInstance.lang = 'es-AR';
    recognitionInstance.interimResults = false;

    recognitionInstance.onresult = (event) => {
      const transcript = event.results[0][0].transcript;
      const textarea = document.getElementById('brain-dump-input');
      if (textarea) {
        textarea.value = (textarea.value ? textarea.value + " " : "") + transcript;
      }
      stopVoice();
    };

    recognitionInstance.onerror = () => {
      simulateVoiceFallback();
    };

    recognitionInstance.onend = () => {
      stopVoice();
    };
  }
}

function toggleVoice() {
  if (window.neuroAudio) window.neuroAudio.playSoftTap();
  if (isListening) {
    stopVoice();
  } else {
    startVoice();
  }
}

function startVoice() {
  const btn = document.getElementById('voice-btn');
  const wave = document.getElementById('voice-wave-indicator');
  isListening = true;
  if (btn) {
    btn.classList.add('neu-pressed', 'text-indigo-600');
    btn.classList.remove('neu-btn');
  }
  if (wave) wave.classList.remove('hidden');

  if (recognitionInstance) {
    try {
      recognitionInstance.start();
    } catch (e) {
      simulateVoiceFallback();
    }
  } else {
    simulateVoiceFallback();
  }
}

function simulateVoiceFallback() {
  const sampleTexts = [
    "Tengo que testear los endpoints del backend en Postman, después escribir el resumen ejecutivo del informe y finalmente armar las 7 diapositivas de la entrega en Figma.",
    "Preparar la base de datos de usuarios, configurar los servicios en Riverpod y redactar el manual de testing móvil.",
    "Revisar los requerimientos del profesor de DAM, diseñar los wireframes en papel y programar el Single Task Viewport en Flutter."
  ];
  const chosen = sampleTexts[Math.floor(Math.random() * sampleTexts.length)];
  const textarea = document.getElementById('brain-dump-input');
  
  let charIdx = 0;
  textarea.value = "";
  const typeInterval = setInterval(() => {
    if (charIdx < chosen.length) {
      textarea.value += chosen.charAt(charIdx);
      charIdx++;
    } else {
      clearInterval(typeInterval);
      stopVoice();
    }
  }, 22);
}

function stopVoice() {
  isListening = false;
  const btn = document.getElementById('voice-btn');
  const wave = document.getElementById('voice-wave-indicator');
  if (btn) {
    btn.classList.remove('neu-pressed', 'text-indigo-600');
    btn.classList.add('neu-btn');
  }
  if (wave) wave.classList.add('hidden');
  if (recognitionInstance) {
    try { recognitionInstance.stop(); } catch (e) {}
  }
}

function loadPresetPrompt(type) {
  if (window.neuroAudio) window.neuroAudio.playSoftTap();
  const textarea = document.getElementById('brain-dump-input');
  if (type === 'dam') {
    textarea.value = "Tengo que testear los endpoints del backend en Postman, redactar el resumen ejecutivo de 2 párrafos para el informe y armar las 7 diapositivas visuales en Figma para la entrega de ITU.";
  } else if (type === 'flutter') {
    textarea.value = "Definir los tokens de color Soft Paper en Dart, armar la NeumorphicCard reutilizable y programar la pantalla de foco 1 a 1 con Riverpod.";
  } else if (type === 'general') {
    textarea.value = "Responder emails del cliente, corregir el bug de navegación y subir la versión beta a Google Play Store.";
  }
}

/**
 * Screen Transitions & Flow
 */
function startProcessing() {
  if (window.neuroAudio) window.neuroAudio.playSoftTap();
  const rawInput = document.getElementById('brain-dump-input').value;
  window.dagEngine.parseBrainDump(rawInput);

  switchScreen(currentScreenId, 'screen-processing');
  currentScreenId = 'screen-processing';

  const statusMessages = [
    "Descomprimiendo lenguaje natural...",
    "Eliminando ruido y fricción cognitiva...",
    "Construyendo Grafo Acíclico Dirigido (DAG)...",
    "Aislando tu primer paso de foco atómico..."
  ];

  let msgIdx = 0;
  const msgEl = document.getElementById('processing-status-text');
  const msgInterval = setInterval(() => {
    msgIdx++;
    if (msgEl && statusMessages[msgIdx]) {
      msgEl.innerText = statusMessages[msgIdx];
    }
  }, 400);

  setTimeout(() => {
    clearInterval(msgInterval);
    switchScreen('screen-processing', 'screen-focus');
    currentScreenId = 'screen-focus';
    loadCurrentFocusTask();
    startZenTimer();
  }, 1600);
}

function loadCurrentFocusTask() {
  activeTask = window.dagEngine.getCurrentExecutableTask();

  if (!activeTask) {
    showCompletionCelebration();
    return;
  }

  // Calculate progress stats
  const allNodes = window.dagEngine.getTopologicalOrder();
  const total = allNodes.length;
  const completedCount = allNodes.filter(n => n.completed).length;
  const currentNum = Math.min(completedCount + 1, total);

  const progEl = document.getElementById('task-progress-indicator');
  if (progEl) progEl.innerText = `Paso ${currentNum} de ${total}`;

  const titleEl = document.getElementById('task-title');
  if (titleEl) titleEl.innerText = activeTask.title;

  const catEl = document.getElementById('task-category');
  if (catEl) catEl.innerText = activeTask.category;

  const subEl = document.getElementById('task-subtext');
  if (subEl) subEl.innerText = activeTask.subtext;

  const timeEl = document.getElementById('task-time-estimate');
  if (timeEl) timeEl.innerText = `Tiempo de Flujo: ${activeTask.estimatedMinutes} min`;
}

function completeTask() {
  if (window.neuroAudio) {
    try { window.neuroAudio.playZenChime(); } catch(e) {}
  }
  
  if (!activeTask) {
    activeTask = window.dagEngine.getCurrentExecutableTask();
  }
  
  if (activeTask) {
    window.dagEngine.markTaskCompleted(activeTask.id);
  } else {
    const all = window.dagEngine.getTopologicalOrder();
    const next = all.find(n => !n.completed);
    if (next) window.dagEngine.markTaskCompleted(next.id);
  }

  showNotificationBadge("✨ Tarea completada con éxito");
  loadCurrentFocusTask();
}

function showCompletionCelebration() {
  if (window.neuroAudio) {
    try { window.neuroAudio.playZenChime(); } catch(e) {}
  }
  switchScreen(currentScreenId, 'screen-celebration');
  currentScreenId = 'screen-celebration';
  stopZenTimer();
}

function startZenTimer() {
  zenSecondsElapsed = 0;
  clearInterval(zenTimerInterval);
  zenTimerInterval = setInterval(() => {
    zenSecondsElapsed++;
    const mins = Math.floor(zenSecondsElapsed / 60).toString().padStart(2, '0');
    const secs = (zenSecondsElapsed % 60).toString().padStart(2, '0');
    const timerEl = document.getElementById('zen-timer-count');
    if (timerEl) timerEl.innerText = `${mins}:${secs}`;
  }, 1000);
}

function stopZenTimer() {
  clearInterval(zenTimerInterval);
}

function openRescueModal() {
  if (window.neuroAudio) {
    try { window.neuroAudio.playSoftTap(); } catch(e) {}
  }
  const modal = document.getElementById('rescue-modal');
  if (modal) modal.classList.remove('hidden');
}

function closeRescueModal() {
  if (window.neuroAudio) {
    try { window.neuroAudio.playSoftTap(); } catch(e) {}
  }
  const modal = document.getElementById('rescue-modal');
  if (modal) modal.classList.add('hidden');
}

function executeRescueAction(type) {
  closeRescueModal();
  if (window.neuroAudio) {
    try { window.neuroAudio.playSoftTap(); } catch(e) {}
  }
  
  if (!activeTask) {
    activeTask = window.dagEngine.getCurrentExecutableTask();
  }

  if (type === 'split') {
    if (activeTask) {
      window.dagEngine.splitTaskIntoMicroSteps(activeTask.id);
      showNotificationBadge("🔹 Tarea dividida en micro-pasos de 3 minutos");
    }
  } else if (type === 'switch') {
    if (activeTask) {
      window.dagEngine.markTaskCompleted(activeTask.id);
      showNotificationBadge("🔀 Saltaste a la siguiente tarea disponible");
    }
  } else if (type === 'low-energy') {
    window.dagEngine.reorderForLowEnergy();
    showNotificationBadge("⚡ Modo Baja Energía activado");
  }
  
  loadCurrentFocusTask();
}

function openGraphModal() {
  if (window.neuroAudio) window.neuroAudio.playSoftTap();
  renderGraphNodes();
  const modal = document.getElementById('graph-modal');
  if (modal) modal.classList.remove('hidden');
}

function closeGraphModal() {
  if (window.neuroAudio) window.neuroAudio.playSoftTap();
  const modal = document.getElementById('graph-modal');
  if (modal) modal.classList.add('hidden');
}

function renderGraphNodes() {
  const container = document.getElementById('graph-nodes-list');
  if (!container) return;

  const nodes = window.dagEngine.getTopologicalOrder();
  container.innerHTML = '';

  nodes.forEach((node, index) => {
    const isCurrent = activeTask && activeTask.id === node.id;
    const item = document.createElement('div');
    item.className = `p-3.5 rounded-2xl neu-flat flex items-start space-x-3 transition-all ${
      isCurrent ? 'border-2 border-indigo-500 bg-indigo-50/50 shadow-md' : ''
    } ${node.completed ? 'opacity-70 bg-emerald-50/30' : ''}`;

    item.innerHTML = `
      <div class="w-7 h-7 rounded-xl flex items-center justify-center font-bold text-xs shrink-0 ${
        node.completed 
          ? 'bg-emerald-500 text-white' 
          : isCurrent 
            ? 'bg-indigo-600 text-white' 
            : 'neu-pressed text-slate-500'
      }">
        ${node.completed ? '✓' : index + 1}
      </div>
      <div class="flex-1 min-w-0">
        <div class="flex items-center justify-between">
          <span class="text-[10px] font-bold uppercase tracking-wider ${node.completed ? 'text-emerald-600' : isCurrent ? 'text-indigo-600' : 'text-slate-400'}">
            ${node.category}
          </span>
          <span class="text-[10px] font-mono text-slate-400">${node.estimatedMinutes}m</span>
        </div>
        <p class="text-xs font-semibold text-slate-800 truncate mt-0.5">${node.title}</p>
        <p class="text-[11px] text-slate-500 truncate mt-0.5">${node.subtext}</p>
      </div>
    `;
    container.appendChild(item);
  });
}

function toggleAmbientSound() {
  const isPlaying = window.neuroAudio.toggleAmbientNoise();
  const btn = document.getElementById('ambient-btn');
  if (btn) {
    if (isPlaying) {
      btn.classList.add('neu-pressed', 'text-indigo-600');
      btn.classList.remove('neu-btn');
      showNotificationBadge("🌧️ Sonido de Enfoque Activo (Ruido Marrón)");
    } else {
      btn.classList.remove('neu-pressed', 'text-indigo-600');
      btn.classList.add('neu-btn');
      showNotificationBadge("🔇 Sonido Ambiental Pausado");
    }
  }
}

function toggleMuteFX() {
  const isMuted = window.neuroAudio.toggleMute();
  const btn = document.getElementById('mute-fx-btn');
  if (btn) {
    btn.innerText = isMuted ? '🔇' : '🔔';
    showNotificationBadge(isMuted ? 'Efectos de sonido silenciados' : 'Campana zen activada');
  }
}

function toggleSimulatorFullscreen() {
  if (window.neuroAudio) window.neuroAudio.playSoftTap();
  document.body.classList.toggle('fullscreen-app');
}

function showNotificationBadge(msg) {
  const toast = document.getElementById('quick-toast');
  if (toast) {
    toast.innerText = msg;
    toast.classList.remove('opacity-0', 'pointer-events-none', 'translate-y-4');
    toast.classList.add('opacity-100', 'translate-y-0');
    setTimeout(() => {
      toast.classList.remove('opacity-100', 'translate-y-0');
      toast.classList.add('opacity-0', 'pointer-events-none', 'translate-y-4');
    }, 2800);
  }
}
