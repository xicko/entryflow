import 'package:entryflow/base_controller.dart';
import 'package:entryflow/controllers/add_item_controller.dart';
import 'package:entryflow/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddItemModal extends StatelessWidget {
  const AddItemModal({super.key});

  void _closeModal() {
    BaseController.to.addItemModalAnim.value = false;

    // fade out animation duussanii daraa visibility untraana
    Future.delayed(Duration(milliseconds: 300), () {
      BaseController.to.isAddItemModalVisible.value = false;
    });
  }

  void nemeh(BuildContext context) async {
    // controlleruudig n ashiglaj shine item listruu nemeh
    AddItemController.to.addNewItem(
      context,
      BaseController.to.titleController.text,
      BaseController.to.imageUrlController.text,
    );

    // item nemsnii daraa modal haaj, text inputee hooslono
    _closeModal();
    BaseController.to.titleController.clear();
    BaseController.to.imageUrlController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Visibility(
        visible: BaseController.to.isAddItemModalVisible.value,
        child: AnimatedOpacity(
            opacity: BaseController.to.addItemModalAnim.value ? 1 : 0,
            duration: Duration(milliseconds: 200),
            child: Center(
                child: Wrap(
              children: [
                Material(
                    elevation: 20,
                    color: AppColors.addItemModalBackgroundColor(
                        Theme.of(context).brightness),
                    shadowColor: Colors.black,
                    borderRadius: BorderRadius.all(Radius.circular(24)),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: 200,
                        maxWidth: 300,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 30,
                                vertical: 20,
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    'Жагсаалтад нэмэх',
                                    style: TextStyle(
                                        color: AppColors.searchInputLabelColor(
                                            Theme.of(context).brightness),
                                        fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(height: 8),
                                  TextField(
                                    // title input controller
                                    controller:
                                        BaseController.to.titleController,
                                    decoration: InputDecoration(
                                      hintText: 'Title',
                                    ),
                                  ),
                                  TextField(
                                    // image url input controller
                                    controller:
                                        BaseController.to.imageUrlController,
                                    decoration: InputDecoration(
                                        hintText: 'Image link/url'),
                                  ),
                                ],
                              )),
                          SizedBox(height: 8),

                          // Buttons
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                  child: ElevatedButton(
                                      onPressed: _closeModal,
                                      style: ElevatedButton.styleFrom(
                                          padding: EdgeInsets.all(12),
                                          minimumSize: Size(0, 0),
                                          tapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(16),
                                          )),
                                          elevation: 0,
                                          backgroundColor: AppColors
                                              .cancelButtonBackgroundColor(
                                                  Theme.of(context).brightness),
                                          foregroundColor:
                                              AppColors.searchInputLabelColor(
                                                  Theme.of(context)
                                                      .brightness)),
                                      child: Text('Cancel'))),
                              Expanded(
                                  child: ElevatedButton(
                                      onPressed: () {
                                        // controlleruudig n ashiglaj shine item listruu nemeh
                                        AddItemController.to.addNewItem(
                                          context,
                                          BaseController
                                              .to.titleController.text,
                                          BaseController
                                              .to.imageUrlController.text,
                                        );
                                        _closeModal(); // item nemsnii daraa modal haah
                                      },
                                      style: ElevatedButton.styleFrom(
                                          padding: EdgeInsets.all(12),
                                          minimumSize: Size(0, 0),
                                          tapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.only(
                                                  bottomRight:
                                                      Radius.circular(16))),
                                          elevation: 0,
                                          backgroundColor:
                                              AppColors.addItemColor(
                                                  Theme.of(context).brightness),
                                          foregroundColor: Colors.black),
                                      child: Text('Add Item',
                                          style: TextStyle(
                                            color: Colors.white,
                                          ))))
                            ],
                          )
                        ],
                      ),
                    )),
              ],
            )))));
  }
}
