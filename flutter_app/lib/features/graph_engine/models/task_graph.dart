import 'task_node.dart';

class TaskEdge {
  final String fromId;
  final String toId;

  const TaskEdge({required this.fromId, required this.toId});
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
}
