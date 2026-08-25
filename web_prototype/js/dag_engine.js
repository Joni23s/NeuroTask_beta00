/**
 * NeuroTask DAG Engine (Directed Acyclic Graph & Topological Sort)
 * Decomposes natural language input into atomic actionable steps,
 * calculates topological dependencies, handles task subdivisions and energy re-balancing.
 */

class TaskNode {
  constructor({ id, title, category, subtext, estimatedMinutes = 15, energyLevel = 'medium', dependencies = [], completed = false, isAtomicSubstep = false }) {
    this.id = id;
    this.title = title;
    this.category = category;
    this.subtext = subtext;
    this.estimatedMinutes = estimatedMinutes;
    this.energyLevel = energyLevel; // 'low', 'medium', 'high'
    this.dependencies = dependencies; // array of prerequisite task IDs
    this.completed = completed;
    this.isAtomicSubstep = isAtomicSubstep;
  }
}

class DAGTaskEngine {
  constructor() {
    this.nodes = new Map(); // id -> TaskNode
    this.edges = []; // [{ from, to }]
    this.completedOrder = [];
  }

  clear() {
    this.nodes.clear();
    this.edges = [];
    this.completedOrder = [];
  }

  addNode(node) {
    this.nodes.set(node.id, node);
  }

  addEdge(fromId, toId) {
    if (!this.edges.some(e => e.from === fromId && e.to === toId)) {
      this.edges.push({ from: fromId, to: toId });
      const targetNode = this.nodes.get(toId);
      if (targetNode && !targetNode.dependencies.includes(fromId)) {
        targetNode.dependencies.push(fromId);
      }
    }
  }

  /**
   * Topological Sort using Kahn's Algorithm
   * Returns list of TaskNodes in executable order.
   */
  getTopologicalOrder() {
    const inDegree = new Map();
    const adj = new Map();

    this.nodes.forEach((node, id) => {
      inDegree.set(id, 0);
      adj.set(id, []);
    });

    this.edges.forEach(({ from, to }) => {
      if (adj.has(from) && inDegree.has(to)) {
        adj.get(from).push(to);
        inDegree.set(to, inDegree.get(to) + 1);
      }
    });

    const queue = [];
    inDegree.forEach((deg, id) => {
      if (deg === 0) queue.push(id);
    });

    const sortedList = [];
    while (queue.length > 0) {
      const currentId = queue.shift();
      const node = this.nodes.get(currentId);
      if (node) sortedList.push(node);

      const neighbors = adj.get(currentId) || [];
      neighbors.forEach(neighborId => {
        inDegree.set(neighborId, inDegree.get(neighborId) - 1);
        if (inDegree.get(neighborId) === 0) {
          queue.push(neighborId);
        }
      });
    }

    // Fallback if cycles exist or unconnected nodes
    if (sortedList.length < this.nodes.size) {
      this.nodes.forEach((node) => {
        if (!sortedList.includes(node)) sortedList.push(node);
      });
    }

    return sortedList;
  }

  /**
   * Returns the single next executable task (dependencies met and not completed)
   */
  getCurrentExecutableTask() {
    const sorted = this.getTopologicalOrder();
    for (const node of sorted) {
      if (!node.completed) {
        const allDepsCompleted = node.dependencies.every(depId => {
          const depNode = this.nodes.get(depId);
          return depNode && depNode.completed;
        });
        if (allDepsCompleted) {
          return node;
        }
      }
    }
    // If all tasks are completed
    return null;
  }

  /**
   * Reorder for Low Energy Mode (prioritizes easy, low cognitive demand tasks first)
   */
  reorderForLowEnergy() {
    const uncompleted = Array.from(this.nodes.values()).filter(n => !n.completed);
    uncompleted.sort((a, b) => {
      const energyWeight = { 'low': 1, 'medium': 2, 'high': 3 };
      return (energyWeight[a.energyLevel] || 2) - (energyWeight[b.energyLevel] || 2);
    });
    return uncompleted;
  }

  /**
   * Splits a task into micro-steps of 3 minutes for cognitive rescue
   */
  splitTaskIntoMicroSteps(nodeId) {
    const parent = this.nodes.get(nodeId);
    if (!parent) return null;

    const micro1 = new TaskNode({
      id: `${nodeId}_micro1`,
      title: `Paso Inicial (3 min): Abrir y preparar herramientas para "${parent.title.substring(0, 32)}..."`,
      category: "Desbloqueo Inmediato",
      subtext: "Micro-acción sin fricción: solo tené listos los archivos y la ventana de trabajo.",
      estimatedMinutes: 3,
      energyLevel: "low",
      dependencies: [...parent.dependencies],
      isAtomicSubstep: true
    });

    const micro2 = new TaskNode({
      id: `${nodeId}_micro2`,
      title: `Paso de Acción (5 min): Realizar el primer borrador / prueba inicial`,
      category: parent.category,
      subtext: `Continuación enfocada de ${parent.title}`,
      estimatedMinutes: 5,
      energyLevel: "medium",
      dependencies: [micro1.id],
      isAtomicSubstep: true
    });

    // Remove parent or replace with micro-steps
    this.nodes.delete(nodeId);
    this.addNode(micro1);
    this.addNode(micro2);

    // Update incoming and outgoing edges
    this.edges = this.edges.map(e => {
      if (e.to === nodeId) return { from: e.from, to: micro1.id };
      if (e.from === nodeId) return { from: micro2.id, to: e.to };
      return e;
    });
    this.addEdge(micro1.id, micro2.id);

    return micro1;
  }

  /**
   * Intelligent Natural Language Parser
   * Generates a realistic DAG from raw unstructured brain dump text.
   */
  parseBrainDump(rawText) {
    this.clear();
    const text = rawText.trim();

    if (!text || text.length < 5) {
      this._loadDefaultPreset();
      return;
    }

    // Split sentences or clauses by comma, period, or connectors
    const cleanClauses = text
      .split(/(?:,|\.|\n| y luego| después| primero| por último| pero antes| antes de)/i)
      .map(s => s.trim())
      .filter(s => s.length > 8);

    if (cleanClauses.length === 0) {
      this._loadDefaultPreset();
      return;
    }

    let prevId = null;
    cleanClauses.slice(0, 6).forEach((clause, index) => {
      const id = `node_${index + 1}`;
      let category = "Ejecución";
      let energy = "medium";
      let mins = 15;

      const lower = clause.toLowerCase();
      if (lower.includes("test") || lower.includes("postman") || lower.includes("endpoint") || lower.includes("código") || lower.includes("programar") || lower.includes("api")) {
        category = "Backend & Integración";
        mins = 15;
        energy = "medium";
      } else if (lower.includes("escribir") || lower.includes("redactar") || lower.includes("informe") || lower.includes("resumen") || lower.includes("doc")) {
        category = "Documentación";
        mins = 20;
        energy = "high";
      } else if (lower.includes("diapositiva") || lower.includes("slide") || lower.includes("presentación") || lower.includes("figma") || lower.includes("diseño")) {
        category = "Diseño & Presentación";
        mins = 15;
        energy = "low";
      } else if (lower.includes("revisar") || lower.includes("leer") || lower.includes("verificar")) {
        category = "Control de Calidad";
        mins = 10;
        energy = "low";
      }

      const node = new TaskNode({
        id,
        title: clause.charAt(0).toUpperCase() + clause.slice(1),
        category,
        subtext: index === 0 ? "Paso 1 del camino crítico. Sin dependencias activas." : `Desbloqueado tras completar el paso previo.`,
        estimatedMinutes: mins,
        energyLevel: energy,
        dependencies: prevId ? [prevId] : []
      });

      this.addNode(node);
      if (prevId) {
        this.addEdge(prevId, id);
      }
      prevId = id;
    });
  }

  _loadDefaultPreset() {
    this.clear();
    const n1 = new TaskNode({
      id: "node_1",
      title: "Testear los endpoints en Postman y verificar respuestas JSON",
      category: "Backend & Integración",
      subtext: "Paso 1 del camino crítico. Sin dependencias activas.",
      estimatedMinutes: 15,
      energyLevel: "medium"
    });

    const n2 = new TaskNode({
      id: "node_2",
      title: "Redactar el resumen ejecutivo de 2 párrafos para el informe",
      category: "Documentación",
      subtext: "Desbloqueado tras validar los endpoints con éxito.",
      estimatedMinutes: 20,
      energyLevel: "high",
      dependencies: ["node_1"]
    });

    const n3 = new TaskNode({
      id: "node_3",
      title: "Armar las 7 diapositivas visuales del Slide Deck en Figma",
      category: "Presentación Final",
      subtext: "Último nodo del grafo. Listo para entrega de cátedra.",
      estimatedMinutes: 15,
      energyLevel: "low",
      dependencies: ["node_2"]
    });

    this.addNode(n1);
    this.addNode(n2);
    this.addNode(n3);

    this.addEdge("node_1", "node_2");
    this.addEdge("node_2", "node_3");
  }
}

window.dagEngine = new DAGTaskEngine();
window.dagEngine._loadDefaultPreset();
