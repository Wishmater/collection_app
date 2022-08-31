import 'package:collection_app/models/collection.dart';
import 'package:collection_app/models/tag.dart';
import 'package:collection_app/providers/collection_provider.dart';
import 'package:collection_app/providers/tag_provider.dart';
import 'package:dartx/dartx.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:from_zero_ui/from_zero_ui.dart';


abstract class TagDAO {

  static DAO buildDao(Tag? model, Tag? parentTag) {
    return DAO(
      id: model?.id,
      classUiNameGetter: (dao) => 'Tag',
      uiNameGetter: (dao) {
        final result = (dao.props['name'] as StringField).value ?? '';
        return '${dao.classUiName}: $result';
      },
      onSaveAPI: (context, dao) {
        return TagProvider.save(context as WidgetRef, TagDAO.buildModel(dao));
      },
      onDidSave: (context, model, dao) {
        if (model!=null && model is Tag) {
          (dao.props['model'] as HiddenValueField<Tag?>).hiddenValue = model;
          final parent = (dao.props['parentTag'] as HiddenValueField<Tag?>).hiddenValue;
          (context as WidgetRef).invalidate(TagProvider.all);
          (context as WidgetRef).invalidate(TagProvider.one.call(model.id));
          if (parent==null) {
            (context as WidgetRef).invalidate(TagProvider.roots);
          } else {
            (context as WidgetRef).invalidate(TagProvider.children.call(parent.id));
            (context as WidgetRef).invalidate(TagProvider.childrenCount.call(parent.id));
            (context as WidgetRef).invalidate(TagProvider.hasChildren.call(parent.id));
          }
        }
      },
      onDeleteAPI: (context, dao) {
        return TagProvider.delete(context as WidgetRef, TagDAO.buildModel(dao));
      },
      onDidDelete: (context, dao) {
        (dao.props['model'] as HiddenValueField<Tag?>).hiddenValue = model;
        final parent = (dao.props['parentTag'] as HiddenValueField<Tag?>).hiddenValue;
        (context as WidgetRef).invalidate(TagProvider.all);
        (context as WidgetRef).invalidate(TagProvider.one.call(dao.id));
        if (parent==null) {
          (context as WidgetRef).invalidate(TagProvider.roots);
        } else {
          (context as WidgetRef).invalidate(TagProvider.children.call(parent.id));
          (context as WidgetRef).invalidate(TagProvider.childrenCount.call(parent.id));
          (context as WidgetRef).invalidate(TagProvider.hasChildren.call(parent.id));
        }
      },
      fieldGroups: [
        FieldGroup(
          fields: {
            'model': HiddenValueField<Tag?>(model),
            'parentTag': HiddenValueField<Tag?>(parentTag),
            'name': StringField(
              uiNameGetter: (field, dao) => 'Tag Name',
              value: model?.name,
              validatorsGetter: (field, dao) => [
                fieldValidatorRequired,
              ],
            ),
          },
        ),
      ],
    );
  }

  static Tag buildModel(DAO dao) {
    final props = dao.props;
    final originalModel = (props['model'] as HiddenValueField<Tag?>).hiddenValue;
    final result = Tag()
      ..name = (props['name'] as StringField).value ?? ''
      ..dateCreated = originalModel?.dateCreated ?? DateTime.now()
      ..itemCount = originalModel?.itemCount ?? 0
      ..parentTag.value = (props['parentTag'] as HiddenValueField<Tag?>).hiddenValue;
    if (dao.id!=null) result.id = dao.id!;
    return result;
  }

}