import 'package:entryflow/base_controller.dart';
import 'package:entryflow/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ListSearch extends StatelessWidget {
  const ListSearch({super.key});

  @override
  Widget build(BuildContext context) {
    // SizedBox ashiglaj input button hoyriin height tentsuulev
    return SizedBox(
      height: 48,
      child: Row(
        children: [
          // SEARCH INPUT UI
          Expanded(
              child: Material(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8), bottomLeft: Radius.circular(8)),
            elevation: 0,
            child: TextField(
              controller: BaseController.to.searchController,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.searchInputTextColor(
                    Theme.of(context).brightness),
              ),
              cursorColor: AppColors.searchInputCursorColor(
                  Theme.of(context).brightness),
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.searchInputFillColor(
                    Theme.of(context).brightness),
                labelText: 'Filter',
                labelStyle: TextStyle(
                    color: AppColors.searchInputLabelColor(
                        Theme.of(context).brightness),
                    fontWeight: FontWeight.w500),
                iconColor: AppColors.searchInputIconColor(
                    Theme.of(context).brightness),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      bottomLeft: Radius.circular(8)),
                  borderSide: BorderSide(
                      color: AppColors.searchInputFocusedBorderSideColor(
                          Theme.of(context).brightness)),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      bottomLeft: Radius.circular(8)),
                ),
              ),
              onChanged: (text) {
                // search input-d text bichigdsen uyd isSearchMode flag-g true bolgono
                BaseController.to.isSearchMode.value = text.isNotEmpty;
              },
            ),
          )),

          // SEARCH BUTTON UI
          Container(
              height: 48,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                      color: AppColors.searchButtonBorderColor(
                          Theme.of(context).brightness),
                      width: 1),
                  bottom: BorderSide(
                      color: AppColors.searchButtonBorderColor(
                          Theme.of(context).brightness),
                      width: 1),
                  right: BorderSide(
                      color: AppColors.searchButtonBorderColor(
                          Theme.of(context).brightness),
                      width: 1),
                  left: BorderSide.none,
                ),
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(8),
                    bottomRight: Radius.circular(8)),
              ),
              child: Obx(
                () => ElevatedButton(
                  // haih tovch zuvhun search input ashiglagdaj bh uyd ajillana
                  onPressed: BaseController.to.isSearchMode.value
                      ? () {
                          BaseController.to.performSearch(context);
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.searchButtonForegroundColor(
                        Theme.of(context).brightness),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(8),
                          bottomRight: Radius.circular(8)),
                    ),
                  ),
                  child: Icon(
                    BaseController.to.isSearchMode.value
                        ? Icons.search_rounded
                        : Icons.search_off,
                    color: BaseController.to.isSearchMode.value
                        ? Color.fromARGB(255, 37, 37, 37)
                        : AppColors.searchButtonIconColor(
                            Theme.of(context).brightness),
                    size: 30,
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
