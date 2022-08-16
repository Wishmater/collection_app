import 'package:collection_app/models/collection.dart';
import 'package:collection_app/providers/collection_provider.dart';
import 'package:dartx/dartx.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:from_zero_ui/from_zero_ui.dart';


abstract class CollectionDAO {

  static DAO buildDao(CollectionData? model){
    return DAO(
      id: model?.id,
      classUiNameGetter: (dao) => 'Collection',
      uiNameGetter: (dao) {
        final result = (dao.props['name'] as StringField).value ?? '';
        return result.isBlank ? dao.classUiName : result;
      },
      onSaveAPI: (context, dao) {
        return CollectionProvider.save(context as WidgetRef, CollectionDAO.buildModel(dao));
      },
      onDidSave: (context, model, dao) {
        if (model!=null && model is CollectionData) {
          (dao.props['model'] as HiddenValueField<CollectionData?>).hiddenValue = model;
          (context as WidgetRef).invalidate(CollectionProvider.all);
        }
      },
      fieldGroups: [
        FieldGroup(
          fields: {
            'model': HiddenValueField<CollectionData?>(model),
            'name': StringField(
              uiNameGetter: (field, dao) => 'Collection Name',
              value: model?.name,
              validatorsGetter: (field, dao) => [
                fieldValidatorRequired,
              ],
            ),
            'baseDirectory': FileField(
              uiNameGetter: (field, dao) => 'Base Directory',
              value: model?.name,
              pickDirectory: true,
              enableDragAndDrop: true,
              allowDragAndDropInWholeScreen: true,
              onValueChanged: (dao, field, value) {
                print (value);
              },
              validatorsGetter: (field, dao) => [
                fieldValidatorRequired,
              ],
            ),
          },
        ),
      ],
    );
  }

  static CollectionData buildModel(DAO dao) {
    final props = dao.props;
    final originalModel = (props['model'] as HiddenValueField<CollectionData?>).hiddenValue;
    final result = CollectionData()
        ..name = (props['name'] as StringField).value ?? ''
        ..baseDirectory = (props['baseDirectory'] as FileField).value ?? ''
        ..dateCreated = originalModel?.dateCreated ?? DateTime.now()
        ..dateLastOpened = originalModel?.dateLastOpened ?? DateTime.now()
        ..itemCount = originalModel?.itemCount ?? 0
        ..tagCount = originalModel?.tagCount ?? 0;
    if (dao.id!=null) result.id = dao.id!;
    return result;
  }

}