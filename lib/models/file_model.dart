class FileModel {
  final String id;
  final String fileName;
  final String filePath;
  final int fileSize;
  final String fileType;
  final DateTime uploadedAt;

  FileModel({
    required this.id,
    required this.fileName,
    required this.filePath,
    required this.fileSize,
    required this.fileType,
    required this.uploadedAt,
  });

  factory FileModel.fromJson(Map<String, dynamic> json) {
    return FileModel(
      id: json['id'] as String? ?? '',
      fileName: json['file_name'] as String? ?? '',
      filePath: json['file_path'] as String? ?? '',
      fileSize: json['file_size'] as int? ?? 0,
      fileType: json['file_type'] as String? ?? '',
      uploadedAt: DateTime.parse(json['uploaded_at'] as String? ?? DateTime.now().toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'file_name': fileName,
      'file_path': filePath,
      'file_size': fileSize,
      'file_type': fileType,
      'uploaded_at': uploadedAt.toIso8601String(),
    };
  }

  String get fileSizeInMB => (fileSize / (1024 * 1024)).toStringAsFixed(2);

  bool get isValidSize => fileSize <= 10 * 1024 * 1024; // 10 MB
}