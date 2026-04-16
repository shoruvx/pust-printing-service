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
  final TextEditingController _notesCtrl = TextEditingController();

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
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            return Container(
              margin: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom, left: 16, right: 16, top: 24),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E2E),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white.withOpacity(0.1)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Configure File', style: const TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1)),
                  const SizedBox(height: 8),
                  Text(file.fileName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold), maxLines: 2, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 24),
                  
                  // Copies
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Copies', style: TextStyle(fontSize: 16)),
                      Container(
                        decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(12)),
                        child: Row(
                          children: [
                            IconButton(icon: const Icon(Icons.remove, size: 20), onPressed: () { if (copies > 1) setModalState(() => copies--); }),
                            SizedBox(width: 24, child: Center(child: Text('$copies', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)))),
                            IconButton(icon: const Icon(Icons.add, size: 20), onPressed: () { setModalState(() => copies++); }),
                          ],
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Color segment
                  const Text('Color Mode', style: TextStyle(fontSize: 16)),
                  const SizedBox(height: 12),
                  SegmentedButton<PrintColor>(
                    segments: const [
                      ButtonSegment(value: PrintColor.blackAndWhite, label: Text('B&W (3৳)')),
                      ButtonSegment(value: PrintColor.color, label: Text('Color (5৳)')),
                    ],
                    selected: {color},
                    onSelectionChanged: (Set<PrintColor> newSelection) {
                      setModalState(() => color = newSelection.first);
                    },
                    style: SegmentedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      selectedForegroundColor: Colors.white,
                      selectedBackgroundColor: Theme.of(context).primaryColor.withOpacity(0.4),
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Paper Size
                  const Text('Paper Size', style: TextStyle(fontSize: 16)),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(12)),
                    child: DropdownButton<PaperSize>(
                      value: paper,
                      isExpanded: true,
                      underline: const SizedBox(),
                      dropdownColor: const Color(0xFF1E1E2E),
                      items: PaperSize.values.map((p) => DropdownMenuItem(value: p, child: Text(p.name.toUpperCase()))).toList(),
                      onChanged: (val) {
                        if (val != null) setModalState(() => paper = val);
                      },
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Double Sided
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(12)),
                    child: SwitchListTile(
                      title: const Text('Double Sided'),
                      value: doubleSided,
                      activeColor: Theme.of(context).primaryColor,
                      contentPadding: EdgeInsets.zero,
                      onChanged: (val) {
                        setModalState(() => doubleSided = val);
                      },
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
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
                      child: const Text('Save Settings', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                    ),
                  ),
                  const SizedBox(height: 16),
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
    int totalCopies = _selectedFiles.fold(0, (sum, f) => sum + f.copies);
    final appState = context.watch<AppState>();

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
        title: const Text('New Print Order', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Files Header Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('FILES', style: TextStyle(letterSpacing: 1.5, fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white)),
                        TextButton.icon(
                          onPressed: _pickFiles,
                          icon: Icon(Icons.attach_file, color: Theme.of(context).primaryColor, size: 18),
                          label: Text('Pick Files', style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold)),
                        )
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Dropzone or File List
                    if (_selectedFiles.isEmpty)
                      InkWell(
                        onTap: _pickFiles,
                        borderRadius: BorderRadius.circular(20),
                        child: GlassCard(
                          padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
                          child: Container(
                            width: double.infinity,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), shape: BoxShape.circle),
                                  child: const Icon(Icons.upload_file, size: 32, color: Colors.white),
                                ),
                                const SizedBox(height: 16),
                                const Text('Tap to pick files from your device', style: TextStyle(color: Colors.white, fontSize: 16)),
                                const SizedBox(height: 8),
                                const Text('PDF · DOCX · XLSX · PPTX · JPG · PNG', style: TextStyle(color: Colors.white, fontSize: 13)),
                              ],
                            ),
                          ),
                        ),
                      )
                    else
                      ..._selectedFiles.asMap().entries.map((entry) {
                        final i = entry.key;
                        final f = entry.value;
                        return GlassCard(
                          padding: EdgeInsets.zero,
                          margin: const EdgeInsets.only(bottom: 12),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              children: [
                                FileTypeTag(fileName: f.fileName),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(f.fileName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15), maxLines: 1, overflow: TextOverflow.ellipsis),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          _badge('${f.copies}x'),
                                          const SizedBox(width: 8),
                                          _badge(f.printColor == PrintColor.color ? 'Color' : 'B&W'),
                                          const SizedBox(width: 8),
                                          _badge(f.paperSize.name.toUpperCase()),
                                          const SizedBox(width: 8),
                                          _badge(f.isDoubleSided ? '2-Sided' : '1-Sided'),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                IconButton(icon: const Icon(Icons.tune, color: Colors.white), onPressed: () => _configureFile(i)),
                                IconButton(icon: const Icon(Icons.close, color: Colors.white), onPressed: () => setState(() => _selectedFiles.removeAt(i))),
                              ],
                            ),
                          ),
                        );
                      }).toList(),

                    const SizedBox(height: 32),
                    
                    // Special Instructions
                    const Text('SPECIAL INSTRUCTIONS (OPTIONAL)', style: TextStyle(letterSpacing: 1.5, fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white)),
                    const SizedBox(height: 12),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white.withOpacity(0.05)),
                      ),
                      child: TextField(
                        controller: _notesCtrl,
                        maxLines: 4,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          hintText: 'e.g. Staple, spiral bind, urgent...',
                          hintStyle: TextStyle(color: Colors.white),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),

            // Summary Bottom Sheet
            Container(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              decoration: BoxDecoration(
                color: const Color(0xFF161622),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
                border: Border(top: BorderSide(color: Colors.white.withOpacity(0.1))),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.04),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withOpacity(0.05)),
                    ),
                    child: Column(
                      children: [
                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          const Text('Files', style: TextStyle(color: Colors.white)),
                          Text('${_selectedFiles.length}', style: const TextStyle(fontWeight: FontWeight.bold)),
                        ]),
                        const SizedBox(height: 12),
                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          const Text('Total copies', style: TextStyle(color: Colors.white)),
                          Text('$totalCopies', style: const TextStyle(fontWeight: FontWeight.bold)),
                        ]),
                        const Padding(padding: EdgeInsets.symmetric(vertical: 16), child: Divider(height: 1, color: Colors.white10)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Estimated Total', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            Text('৳${totalCost.toStringAsFixed(0)}', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        disabledBackgroundColor: Theme.of(context).primaryColor.withOpacity(0.3),
                      ),
                      onPressed: _selectedFiles.isEmpty || appState.isLoading
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
                        : const Text('Place Order & Get Token', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _badge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
      child: Text(text, style: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold)),
    );
  }
}
