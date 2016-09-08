/*
 Copyright (c) 2003-2015, CKSource - Frederico Knabben. All rights reserved.
 For licensing, see LICENSE.md or http://ckeditor.com/license
 */
CKEDITOR.dialog.add("zupplaceholder", function (a) {
  var b = a.lang.zupplaceholder, a = a.lang.common.generalTab;
  return {
    title: b.title,
    minWidth: 300,
    minHeight: 80,
    contents: [{
      id: "info",
      label: a,
      title: a,
      elements: [{
        id: "name",
        type: "select",
        items: [
          [ 'Número de protocolo', 'item_protocol' ],
          [ 'Nome do solicitante', 'user_name' ],
          [ 'Endereço do solicitante', 'user_address' ],
          [ 'Telefone do solicitante', 'user_phone' ],
          [ 'Documento do solicitante', 'user_document' ],
          [ 'Imagem do relato', 'item_images' ],
          [ 'Nome da categoria do relato', 'category_title' ],
          [ 'Referência', 'item_reference' ],
          [ 'Descrição', 'item_description' ],
          [ 'Data de cadastro', 'item_created_at' ],
          [ 'Data de emissão da notificação', 'notification_created_at' ],
          [ 'Data do vencimento da notificação', 'notification_overdue_at' ],
          [ 'Endereço do relato', 'item_address' ]
        ],
        label: b.name,
        'default': 'numero_protocolo',
        commit: function (a) {
          a.setData("name", this.getValue())
        }
      }]
    }]
  }
});
