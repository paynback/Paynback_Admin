import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pndb_admin/data/services/web_image_compressor.dart';
import 'package:pndb_admin/presentation/viewmodels/channel_partner/channel_partner_bloc.dart';
import 'package:pndb_admin/presentation/viewmodels/fetch_channel_partners/fetch_channel_partners_bloc.dart';
import 'dart:typed_data';
import 'package:web/web.dart' as web;
import 'dart:js_interop';


class CreatePartnerDialog extends StatefulWidget {
  const CreatePartnerDialog({super.key});

  @override
  State<CreatePartnerDialog> createState() => _CreatePartnerDialogState();
}

class _CreatePartnerDialogState extends State<CreatePartnerDialog> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  String? selectedLocation;

  Uint8List? userImageData;
  String? userImageName;
  
  // Updated to handle 2 ID proof images
  List<Uint8List> idProofDataList = [];
  List<String> idProofNameList = [];

  final List<String> keralaDistricts = [
    'Thiruvananthapuram', 'Kollam', 'Pathanamthitta', 'Alappuzha', 'Kottayam',
    'Idukki', 'Ernakulam', 'Thrissur', 'Palakkad', 'Malappuram',
    'Kozhikode', 'Wayanad', 'Kannur', 'Kasaragod'
  ];

  Future<void> _pickFile({
    required String accept,
    required Function(Uint8List data, String name) onFileSelected,
  }) async {
    final input = web.HTMLInputElement();
    input.type = 'file';
    input.accept = accept;
    
    input.addEventListener('change', (web.Event event) {
      final files = input.files;
      if (files != null && files.length > 0) {
        final file = files.item(0);
        if (file != null) {
          final reader = web.FileReader();
          
          reader.addEventListener('loadend', (web.Event event) {
            final result = reader.result;
            if (result != null) {
              final data = (result as JSArrayBuffer).toDart.asUint8List();
              onFileSelected(data, file.name);
            }
          }.toJS);
          
          reader.readAsArrayBuffer(file);
        }
      }
    }.toJS);
    
    input.click();
  }

  Future<void> pickUserImage() async {
    await _pickFile(
      accept: 'image/*',
      onFileSelected: (data, name) async {
        final compressed = await WebImageCompressor.compressImageWeb(data);
        if (compressed != null) {
          setState(() {
            userImageData = compressed;
            userImageName = name;
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Failed to compress image")),
          );
        }
      },
    );
  }


  // Updated method to handle multiple ID proof images
  Future<void> pickIdProof() async {
    if (idProofDataList.length >= 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Maximum 2 ID proof images allowed")),
      );
      return;
    }

    await _pickFile(
      accept: 'image/*',
      onFileSelected: (data, name) async {
        final compressed = await WebImageCompressor.compressImageWeb(data);
        if (compressed != null) {
          setState(() {
            idProofDataList.add(compressed);
            idProofNameList.add(name);
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Failed to compress image")),
          );
        }
      },
    );
  }

  // Method to remove a specific ID proof image
  void removeIdProof(int index) {
    setState(() {
      idProofDataList.removeAt(index);
      idProofNameList.removeAt(index);
    });
  }

  void submitForm(BuildContext context) {
    if (_formKey.currentState!.validate() &&
        userImageData != null &&
        idProofDataList.length == 2) {

      log(userImageData.toString());
      log(idProofDataList[0].toString());
      log(idProofDataList[1].toString());
      
      final profilePictureBase64 = base64Encode(userImageData!);
      final idProofFrontBase64 = base64Encode(idProofDataList[0]);
      final idProofBackBase64 = base64Encode(idProofDataList[1]);
      log('encoded images base64');
      log(profilePictureBase64);
      log(idProofFrontBase64);
      log(idProofBackBase64);
      log(_nameController.text.trim());
      log(_phoneController.text.trim());
      log(selectedLocation!);
      log(_emailController.text.trim());



      context.read<ChannelPartnerCreationCubit>().createPartner(
        name: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
        idProofFront: idProofFrontBase64,
        idProofBack: idProofBackBase64,
        profilePicture: profilePictureBase64,
        district: selectedLocation!,
        email: _emailController.text.trim()
      );
    } else {
      String errorMessage = '';
      if (userImageData == null) {
        errorMessage = 'Please select user image';
      } else if (idProofDataList.length < 2) {
        errorMessage = 'Please select exactly 2 ID proof images';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text('Add Channel Partner'),
      content: SizedBox(
        width: 1000,
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (val) => val == null || val.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: 'Phone'),
                validator: (val) => val == null || val.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (val) => val == null || val.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: selectedLocation,
                decoration: const InputDecoration(labelText: 'Location'),
                items: keralaDistricts.map((district) {
                  return DropdownMenuItem(
                    value: district,
                    child: Text(district),
                  );
                }).toList(),
                onChanged: (value) => setState(() => selectedLocation = value),
                validator: (val) => val == null ? 'Select a location' : null,
              ),
              const SizedBox(height: 16),
              
              // User Image Upload Button
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.image),
                      label: Text(userImageName != null
                          ? 'Image: $userImageName'
                          : 'Upload User Image'),
                      onPressed: pickUserImage,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // ID Proof Upload Section
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.picture_as_pdf),
                      label: Text(
                        idProofDataList.length == 0
                            ? 'Upload ID Proof (0/2)'
                            : idProofDataList.length == 1
                                ? 'Upload ID Proof (1/2)'
                                : 'ID Proofs Complete (2/2)'
                      ),
                      onPressed: idProofDataList.length < 2 ? pickIdProof : null,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Display uploaded images
              if (userImageData != null) ...[
                const Text('User Image:', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Container(
                  height: 130,
                  width: 130,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.memory(
                      userImageData!,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
              
              if (idProofDataList.isNotEmpty) ...[
                const Text('ID Proof Images:', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: List.generate(idProofDataList.length, (index) {
                    return Stack(
                      children: [
                        Container(
                          height: 130,
                          width: 130,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: idProofNameList[index].toLowerCase().contains('.pdf')
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.picture_as_pdf, size: 40),
                                      const SizedBox(height: 4),
                                      Text(
                                        idProofNameList[index],
                                        style: const TextStyle(fontSize: 10),
                                        textAlign: TextAlign.center,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  )
                                : Image.memory(
                                    idProofDataList[index],
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                        // Remove button
                        Positioned(
                          top: 4,
                          right: 4,
                          child: GestureDetector(
                            onTap: () => removeIdProof(index),
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          ),
                        ),
                        // Image number label
                        Positioned(
                          bottom: 4,
                          left: 4,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.7),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              '${index + 1}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
                ),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          child: const Text('Cancel'),
          onPressed: () => Navigator.pop(context),
        ),
        BlocConsumer<ChannelPartnerCreationCubit, ChannelPartnerCreationState>(
          listener: (context, state) {
            if (state is ChannelPartnerCreationSuccess) {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Channel Partner Created Successfully")),
              );
              context.read<FetchChannelPartnersBloc>().add(FetchChannelPartnersRequested());
            } else if (state is ChannelPartnerCreationFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error)),
              );
            }
          },
          builder: (context, state) {
            final isLoading = state is ChannelPartnerCreationLoading;

            return ElevatedButton(
              onPressed: isLoading ? null : () => submitForm(context),
              child: isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : const Text('Create'),
            );
          },
        ),
      ],
    );
  }
}