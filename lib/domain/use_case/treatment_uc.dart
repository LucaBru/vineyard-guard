import 'package:intl/intl.dart';
import 'package:vineyard_guard/data/treatment_repo_impl.dart';
import 'package:vineyard_guard/domain/entity/treatment.dart';
import 'package:vineyard_guard/domain/repository/treament_repo.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class TreatmentUseCase {
  final TreatmentRepo _repo = TreatmentRepoImpl();

  Future<List<Treatment>> treatments() => _repo.treatments();

  void add(Treatment t) => _repo.add(t);

  void remove(String id) => _repo.remove(id);

    Future<PdfDocument> pdf(List<Treatment> treatments) async {
    final PdfDocument document = PdfDocument();

    final PdfPage page = document.pages.add();
    final Size pageSize = page.getClientSize();
    final PdfGrid grid = PdfGrid();

    _drawFooter(page, pageSize);

    grid.columns.add(count: 2);

    final List<String> columnsTitle = [
      'Treatment date',
      'Pesticides used in treatments'
    ];

    final PdfGridRow headerRow = grid.headers.add(1)[0];
    columnsTitle
        .asMap()
        .forEach((index, title) => headerRow.cells[index].value = title);

    headerRow.style.font =
        PdfStandardFont(PdfFontFamily.helvetica, 10, style: PdfFontStyle.bold);
    headerRow.style.backgroundBrush = PdfSolidBrush(PdfColor(68, 114, 196));

    for (var treatment in treatments) {
      PdfGridRow row = grid.rows.add();
      row.cells[0].value = DateFormat('EEE, d/M/y').format(treatment.date);
      row.cells[1].value = treatment.pesticides.keys.join("\n");
    }

    grid.applyBuiltInStyle(PdfGridBuiltInStyle.listTable4Accent5);
    grid.style.cellPadding = PdfPaddings(left: 5, top: 5);
    grid.draw(
        page: page,
        bounds: Rect.fromLTWH(
            0, 0, page.getClientSize().width, page.getClientSize().height));
    return document;
  }

  void _drawFooter(PdfPage page, Size pageSize) {
    final PdfPen linePen =
        PdfPen(PdfColor(142, 170, 219), dashStyle: PdfDashStyle.custom);
    linePen.dashPattern = <double>[3, 3];
    page.graphics.drawLine(linePen, Offset(0, pageSize.height - 100),
        Offset(pageSize.width, pageSize.height - 100));
    const String footerContent =
        'Azienda agricola Brugnera Vito.\r\n\r\nVisnà di Vazzola, Treviso, 31028\r\n\r\nAgri Admin';
    page.graphics.drawString(
        footerContent, PdfStandardFont(PdfFontFamily.helvetica, 9),
        format: PdfStringFormat(alignment: PdfTextAlignment.right),
        bounds: Rect.fromLTWH(pageSize.width - 30, pageSize.height - 70, 0, 0));
  }
}
