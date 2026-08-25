/**
 * NeuroTask Main Interactive Controller
 * Connects UI, State, DAG Engine, Audio and Voice interactions.
 */

let activeTask = null;
let zenTimerInterval = null;
let zenSecondsElapsed = 0;
let isZenTimerRunning = true;
let isLowEnergyActive = false;
let isListening = false;
let recognitionInstance = null;

document.addEventListener('DOMContentLoaded', () => {
  initSpeechRecognition();
  updateClock();
  setInterval(updateClock, 10000);
});

function updateClock() {
  const clockEl = document.getElementById('status-clock');
  if (clockEl) {
    const now = new Date();
    clockEl.innerText = now.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });
  }
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
  window.neuroAudio.playSoftTap();
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
  window.neuroAudio.playSoftTap();
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
  window.neuroAudio.playSoftTap();
  const rawInput = document.getElementById('brain-dump-input').value;
  window.dagEngine.parseBrainDump(rawInput);

  switchScreen('screen-brain-dump', 'screen-processing');

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
    loadCurrentFocusTask();
    startZenTimer();
  }, 1600);
}

function switchScreen(fromId, toId) {
  const fromEl = document.getElementById(fromId);
  const toEl = document.getElementById(toId);
  
  if (fromEl) fromEl.classList.add('hidden');
  if (toEl) {
    toEl.classList.remove('hidden');
    toEl.classList.add('screen-active');
  }
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
  const currentNum = completedCount + 1;

  document.getElementById('task-progress-indicator').innerText = `Paso ${currentNum} de ${total}`;
  document.getElementById('task-title').innerText = activeTask.title;
  document.getElementById('task-category').innerText = activeTask.category;
  document.getElementById('task-subtext').innerText = activeTask.subtext;
  document.getElementById('task-time-estimate').innerText = `Tiempo de Flujo: ${activeTask.estimatedMinutes} min`;
  
  const energyBadge = document.getElementById('task-energy-badge');
  if (energyBadge) {
    if (activeTask.energyLevel === 'low') {
      energyBadge.className = 'text-[11px] font-semibold px-2 py-0.5 rounded-full bg-emerald-100 text-emerald-700';
      energyBadge.innerText = '🌱 Carga Liviana';
    } else if (activeTask.energyLevel === 'high') {
      energyBadge.className = 'text-[11px] font-semibold px-2 py-0.5 rounded-full bg-amber-100 text-amber-700';
      energyBadge.innerText = '⚡ Carga Intensa';
    } else {
      energyBadge.className = 'text-[11px] font-semibold px-2 py-0.5 rounded-full bg-indigo-100 text-indigo-700';
      energyBadge.innerText = '🌊 Carga Moderada';
    }
  }

  // Animate card appearance
  const heroCard = document.getElementById('focus-hero-card');
  if (heroCard) {
    heroCard.style.opacity = '0';
    heroCard.style.transform = 'translateY(8px) scale(0.98)';
    setTimeout(() => {
      heroCard.style.transition = 'all 0.3s cubic-bezier(0.4, 0, 0.2, 1)';
      heroCard.style.opacity = '1';
      heroCard.style.transform = 'translateY(0) scale(1)';
    }, 50);
  }
}

/**
 * Task Completion & Dopamine Flow
 */
function completeTask() {
  if (!activeTask) return;

  window.neuroAudio.playZenCompletionChime();
  activeTask.completed = true;

  const card = document.getElementById('focus-hero-card');
  if (card) {
    card.style.transform = 'scale(1.02)';
    card.style.boxShadow = '0 0 30px rgba(16, 185, 129, 0.4)';
    setTimeout(() => {
      card.style.opacity = '0.2';
      card.style.transform = 'translateY(-12px) scale(0.95)';
    }, 180);
  }

  setTimeout(() => {
    loadCurrentFocusTask();
    resetZenTimer();
  }, 450);
}

function showCompletionCelebration() {
  switchScreen('screen-focus', 'screen-celebration');
  window.neuroAudio.playZenCompletionChime();
}

function resetToBeginning() {
  window.neuroAudio.playSoftTap();
  stopZenTimer();
  window.dagEngine._loadDefaultPreset();
  isLowEnergyActive = false;
  document.getElementById('brain-dump-input').value = "";
  switchScreen('screen-celebration', 'screen-brain-dump');
  switchScreen('screen-focus', 'screen-brain-dump');
}

/**
 * Zen Breathing Timer
 */
function startZenTimer() {
  zenSecondsElapsed = 0;
  isZenTimerRunning = true;
  updateZenTimerDisplay();
  if (zenTimerInterval) clearInterval(zenTimerInterval);
  zenTimerInterval = setInterval(() => {
    if (isZenTimerRunning) {
      zenSecondsElapsed++;
      updateZenTimerDisplay();
    }
  }, 1000);
}

function resetZenTimer() {
  zenSecondsElapsed = 0;
  updateZenTimerDisplay();
}

function stopZenTimer() {
  if (zenTimerInterval) clearInterval(zenTimerInterval);
}

function updateZenTimerDisplay() {
  const el = document.getElementById('zen-timer-count');
  if (el) {
    const mins = Math.floor(zenSecondsElapsed / 60);
    const secs = zenSecondsElapsed % 60;
    el.innerText = `${mins.toString().padStart(2, '0')}:${secs.toString().padStart(2, '0')}`;
  }
}

/**
 * Cognitive Rescue Modal Actions
 */
function openRescueModal() {
  window.neuroAudio.playSoftTap();
  const modal = document.getElementById('rescue-modal');
  if (modal) {
    modal.classList.remove('hidden');
    const sheet = document.getElementById('rescue-sheet-content');
    if (sheet) {
      sheet.style.transform = 'translateY(100%)';
      setTimeout(() => {
        sheet.style.transition = 'transform 0.3s cubic-bezier(0.32, 0.72, 0, 1)';
        sheet.style.transform = 'translateY(0)';
      }, 10);
    }
  }
}

function closeRescueModal() {
  window.neuroAudio.playSoftTap();
  const sheet = document.getElementById('rescue-sheet-content');
  if (sheet) {
    sheet.style.transform = 'translateY(100%)';
    setTimeout(() => {
      const modal = document.getElementById('rescue-modal');
      if (modal) modal.classList.add('hidden');
    }, 280);
  } else {
    const modal = document.getElementById('rescue-modal');
    if (modal) modal.classList.add('hidden');
  }
}

function executeRescueAction(actionType) {
  window.neuroAudio.playSoftTap();
  closeRescueModal();

  if (actionType === 'split' && activeTask) {
    const microNode = window.dagEngine.splitTaskIntoMicroSteps(activeTask.id);
    if (microNode) {
      loadCurrentFocusTask();
      showNotificationBadge("✨ Tarea dividida en micro-pasos de 3 min");
    }
  } else if (actionType === 'low-energy') {
    isLowEnergyActive = true;
    const reordered = window.dagEngine.reorderForLowEnergy();
    if (reordered.length > 0) {
      loadCurrentFocusTask();
      showNotificationBadge("🌱 Modo Baja Energía Activo: Priorizando lo liviano");
    }
  } else if (actionType === 'switch') {
    // Switch to next unblocked task
    const all = window.dagEngine.getTopologicalOrder().filter(n => !n.completed);
    if (all.length > 1) {
      const currentIdx = all.findIndex(n => n.id === activeTask.id);
      const nextIdx = (currentIdx + 1) % all.length;
      activeTask = all[nextIdx];
      
      document.getElementById('task-title').innerText = activeTask.title;
      document.getElementById('task-category').innerText = activeTask.category;
      document.getElementById('task-subtext').innerText = activeTask.subtext;
      showNotificationBadge("🔀 Saltando a rama alternativa");
    } else {
      showNotificationBadge("ℹ️ Solo queda esta tarea en el camino");
    }
  }
}

/**
 * DAG Graph Inspector Modal
 */
function openGraphModal() {
  window.neuroAudio.playSoftTap();
  renderGraphNodes();
  const modal = document.getElementById('graph-modal');
  if (modal) modal.classList.remove('hidden');
}

function closeGraphModal() {
  window.neuroAudio.playSoftTap();
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

/**
 * Ambient Audio Toggle
 */
function toggleAmbientSound() {
  const isPlaying = window.neuroAudio.toggleAmbientNoise();
  const btn = document.getElementById('ambient-btn');
  const icon = document.getElementById('ambient-btn-icon');
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

/**
 * Sound FX Mute Toggle
 */
function toggleMuteFX() {
  const isMuted = window.neuroAudio.toggleMute();
  const btn = document.getElementById('mute-fx-btn');
  if (btn) {
    btn.innerText = isMuted ? '🔇' : '🔔';
    showNotificationBadge(isMuted ? 'Efectos de sonido silenciados' : 'Campana zen activada');
  }
}

/**
 * Fullscreen simulator toggle
 */
function toggleSimulatorFullscreen() {
  window.neuroAudio.playSoftTap();
  document.body.classList.toggle('fullscreen-app');
}

/**
 * Temporary Toast Notification Badge
 */
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
