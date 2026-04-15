import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import '../../services/app_state.dart';
import '../../models/models.dart';
import '../../widgets/common.dart';
import 'token_screen.dart';

class NewOrderScreen extends StatefulWidget {
  const NewOrderScreen({Key? key}) : super(key: key);

  @override
  _NewOrderScreenState createState() => _NewOrderScreenState();
}

class _NewOrderScreenState extends State<NewOrderScreen> {
  List<PrintFile> _selectedFiles = [];

  void _pickFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx', 'xls', 'xlsx', 'ppt', 'pptx', 'jpg', 'png'],
    );
    
    if (result != null) {
      setState(() {
        for (var file in result.files) {
          _selectedFiles.add(PrintFile(fileName: file.name, filePath: file.path ?? ''));
        }
      });
    }
  }

  void _configureFile(int index) {
    PrintFile file = _selectedFiles[index];
    int copies = file.copies;
    PrintColor color = file.printColor;
    PaperSize paper = file.paperSize;
    bool doubleSided = file.isDoubleSided;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            return Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom, left: 16, right: 16, top: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Configure: ${file.fileName}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold), maxLines: 1),
                  const SizedBox(height: 16),
                  
                  // Copies
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Copies'),
                      Row(
                        children: [
                          IconButton(icon: const Icon(Icons.remove), onPressed: () { if (copies > 1) setModalState(() => copies--); }),
                          Text('$copies', style: const TextStyle(fontSize: 18)),
                          IconButton(icon: const Icon(Icons.add), onPressed: () { setModalState(() => copies++); }),
                        ],
                      )
                    ],
                  ),
                  
                  // Color segment
                  const Text('Color Mode'),
                  const SizedBox(height: 8),
                  SegmentedButton<PrintColor>(
                    segments: const [
                      ButtonSegment(value: PrintColor.blackAndWhite, label: Text('B&W (3৳)')),
                      ButtonSegment(value: PrintColor.color, label: Text('Color (5৳)')),
                    ],
                    selected: {color},
                    onSelectionChanged: (Set<PrintColor> newSelection) {
                      setModalState(() => color = newSelection.first);
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  // Paper Size
                  const Text('Paper Size'),
                  DropdownButton<PaperSize>(
                    value: paper,
                    isExpanded: true,
                    items: PaperSize.values.map((p) => DropdownMenuItem(value: p, child: Text(p.name.toUpperCase()))).toList(),
                    onChanged: (val) {
                      if (val != null) setModalState(() => paper = val);
                    },
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Double Sided
                  SwitchListTile(
                    title: const Text('Double Sided'),
                    value: doubleSided,
                    contentPadding: EdgeInsets.zero,
                    onChanged: (val) {
                      setModalState(() => doubleSided = val);
                    },
                  ),
                  
                  const SizedBox(height: 24),
                  
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _selectedFiles[index] = PrintFile(
                            fileName: file.fileName,
                            filePath: file.filePath,
                            copies: copies,
                            printColor: color,
                            paperSize: paper,
                            isDoubleSided: doubleSided,
                          );
                        });
                        Navigator.pop(ctx);
                      },
                      child: const Text('Save Settings'),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            );
          }
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    double totalCost = _selectedFiles.fold(0.0, (sum, f) => sum + f.cost);
    final appState = context.watch<AppState>();

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(title: const Text('Create Order'), backgroundColor: Colors.transparent),
      body: AmbientBackground(child: Column(
        children: [
          Expanded(
            child: _selectedFiles.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.file_upload, size: 80, color: Colors.grey.shade700),
                      const SizedBox(height: 16),
                      const Text('Add files to print', style: TextStyle(color: Colors.grey, fontSize: 18)),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.add),
                        label: const Text('Pick Files'),
                        onPressed: _pickFiles,
                      )
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: _selectedFiles.length,
                  itemBuilder: (context, i) {
                    final f = _selectedFiles[i];
                    return GlassCard(
                      padding: EdgeInsets.zero,
                      child: ListTile(
                        leading: FileTypeTag(fileName: f.fileName),
                        title: Text(f.fileName, maxLines: 1, overflow: TextOverflow.ellipsis),
                        subtitle: Text('${f.copies} Copies • ${f.printColor == PrintColor.color ? 'Color' : 'B&W'} • ${f.isDoubleSided ? 'Double-sided' : 'Single-sided'}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('BDT ${f.cost.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                            IconButton(icon: Icon(Icons.settings, color: Theme.of(context).primaryColor), onPressed: () => _configureFile(i)),
                            IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => setState(() => _selectedFiles.removeAt(i))),
                          ],
                        ),
                      ),
                    );
                  },
                ),
          ),
          
          if (_selectedFiles.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                boxShadow: const [BoxShadow(color: Colors.black26, offset: Offset(0, -4), blurRadius: 8)],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total Estimate:', style: TextStyle(fontSize: 18)),
                      Text('BDT ${totalCost.toStringAsFixed(2)}', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _pickFiles,
                          child: const Text('Add More Files'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: appState.isLoading 
                            ? null 
                            : () async {
                              await context.read<AppState>().placeOrder(_selectedFiles);
                              
                              if (!mounted) return;
                              final newOrders = context.read<AppState>().orders;
                              final token = newOrders.isNotEmpty ? newOrders.first.token : 'T000';
                              
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => TokenScreen(token: token)));
                            },
                          child: appState.isLoading 
                            ? const CircularProgressIndicator(color: Colors.white) 
                            : const Text('Place Order', style: TextStyle(fontSize: 16)),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )
        ],
      )),
    );
  }
}
