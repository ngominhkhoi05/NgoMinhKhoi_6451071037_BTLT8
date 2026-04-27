import '../models/image_item_model.dart';
import '../utils/database_helper.dart';

class ImageController {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<List<ImageItem>> getAllImages() async {
    return await _dbHelper.getAllImages();
  }

  Future<ImageItem> saveImage() async {
    final bytes = await FileHelper.generatePlaceholderImage();
    final filename = 'image_${DateTime.now().millisecondsSinceEpoch}.png';
    final path = await FileHelper.saveImage(bytes, filename);

    final image = ImageItem(path: path, name: filename);
    return await _dbHelper.insertImage(image);
  }

  Future<int> deleteImage(ImageItem image) async {
    await FileHelper.deleteImageFile(image.path);
    return await _dbHelper.deleteImage(image.id!);
  }
}
