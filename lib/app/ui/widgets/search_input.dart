import 'package:auto_master/app/ui/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:searchfield/searchfield.dart';

class SearchInput extends StatefulWidget {
  const SearchInput({
    Key? key,
    this.node,
    this.hint,
    this.isError = false,
    this.controller,
    this.onTap,
    this.enabled = true,
    this.suggestions,
  }) : super(key: key);

  final FocusNode? node;
  final String? hint;
  final bool isError;
  final TextEditingController? controller;
  final Function(SearchFieldListItem<Object?>)? onTap;
  final List<SearchFieldListItem<Object?>>? suggestions;
  final bool enabled;

  @override
  State<SearchInput> createState() => _SearchInputState();
}

class _SearchInputState extends State<SearchInput> {
  @override
  void initState() {
    super.initState();

    widget.node?.addListener(onFocusChange);
  }

  @override
  void dispose() {
    widget.node?.removeListener(onFocusChange);
    super.dispose();
  }

  void onFocusChange() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      height: 46.0,
      duration: kThemeAnimationDuration,
      decoration: BoxDecoration(
        border: widget.node!.hasFocus
            ? Border.all(
                width: 2,
                color: AppColors.main,
              )
            : null,
        boxShadow: [
          BoxShadow(
            blurRadius: widget.node!.hasFocus ? 3 : 3,
            color: widget.node!.hasFocus
                ? AppColors.main.withOpacity(.5)
                : Colors.black.withOpacity(.25),
          ),
        ],
        borderRadius: BorderRadius.circular(60.0),
      ),
      child: SearchField(
        enabled: widget.enabled,
        controller: widget.controller,
        suggestions: widget.suggestions ?? [],
        itemHeight: 44,
        focusNode: widget.node,
        onSuggestionTap: widget.onTap,
        searchStyle: const TextStyle(color: Colors.black),
        suggestionItemDecoration: const BoxDecoration(color: Colors.white),
        searchInputDecoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 22.0,
            vertical: 8.0,
          ),
          isDense: false,
          filled: true,
          fillColor: Colors.white,
          hintStyle: AppTextStyle.s14w400.copyWith(
            color: AppColors.grey,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(60.0),
            borderSide: BorderSide.none,
          ),
        ),
        hint: widget.hint ?? 'Выберите марку',
      ),
    );
  }
}
