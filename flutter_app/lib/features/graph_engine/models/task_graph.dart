import 'task_node.dart';

class TaskEdge {
  final String fromId;
  final String toId;

  const TaskEdge({required this.fromId, required this.toId});

  Map<String, dynamic> toJson() {
    return {
      'fromId': fromId,
      'toId': toId,
    };
  }

  factory TaskEdge.fromJson(Map<String, dynamic> json) {
    return TaskEdge(
      fromId: json['fromId'] as String,
      toId: json['toId'] as String,
    );
  }
}

class TaskGraph {
  final List<TaskNode> nodes;
  final List<TaskEdge> edges;

  const TaskGraph({
    this.nodes = const [],
    this.edges = const [],
  });

  TaskGraph copyWith({
    List<TaskNode>? nodes,
    List<TaskEdge>? edges,
  }) {
    return TaskGraph(
      nodes: nodes ?? this.nodes,
      edges: edges ?? this.edges,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nodes': nodes.map((n) => n.toJson()).toList(),
      'edges': edges.map((e) => e.toJson()).toList(),
    };
  }

  factory TaskGraph.fromJson(Map<String, dynamic> json) {
    return TaskGraph(
      nodes: (json['nodes'] as List<dynamic>?)
              ?.map((n) => TaskNode.fromJson(n as Map<String, dynamic>))
              .toList() ??
          const [],
      edges: (json['edges'] as List<dynamic>?)
              ?.map((e) => TaskEdge.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );
  }
}
