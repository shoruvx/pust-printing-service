class FileModel {
  String fileName;
  String path;
  int size;
  String uploadStatus;

  FileModel({required this.fileName, required this.path, required this.size, required this.uploadStatus});

  @override
  String toString() {
    return 'FileModel(fileName: $fileName, path: $path, size: $size, uploadStatus: $uploadStatus)';
  }
}