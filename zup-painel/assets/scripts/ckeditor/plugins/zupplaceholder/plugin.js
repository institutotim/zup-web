/*
 Copyright (c) 2003-2015, CKSource - Frederico Knabben. All rights reserved.
 For licensing, see LICENSE.md or http://ckeditor.com/license
 */
(function () {
  CKEDITOR.plugins.add("zupplaceholder", {
    requires: "widget,dialog",
    lang: "pt-br",
    icons: "zupplaceholder",
    hidpi: !0,
    onLoad: function () {
      CKEDITOR.addCss(".cke_placeholder{background-color:#ff0}")
    },
    init: function (a) {
      var b = a.lang.zupplaceholder;
      CKEDITOR.dialog.add("zupplaceholder", this.path + "dialogs/zupplaceholder.js");
      a.widgets.add("zupplaceholder", {
        dialog: "zupplaceholder",
        pathName: b.pathName, template: '<span class="cke_placeholder">[[]]</span>', downcast: function () {
          return new CKEDITOR.htmlParser.text("[[" + this.data.name + "]]")
        }, init: function () {
          this.setData("name", this.element.getText().slice(2, -2))
        }, data: function () {
          this.element.setText("[[" + this.data.name + "]]")
        }
      });
      a.ui.addButton && a.ui.addButton("CreatePlaceholder", {
        label: b.toolbar,
        command: "zupplaceholder",
        toolbar: "insert,5",
        icon: "zupplaceholder"
      })
    },
    afterInit: function (a) {
      var b = /\[\[([^\[\]])+\]\]/g;
      a.dataProcessor.dataFilter.addRules({
        text: function (f, d) {
          var e = d.parent && CKEDITOR.dtd[d.parent.name];
          if (!e || e.span)return f.replace(b, function (b) {
            var c = null, c = new CKEDITOR.htmlParser.element("span", {"class": "cke_placeholder"});
            c.add(new CKEDITOR.htmlParser.text(b));
            c = a.widgets.wrapElement(c, "zupplaceholder");
            return c.getOuterHtml()
          })
        }
      })
    }
  })
})();
