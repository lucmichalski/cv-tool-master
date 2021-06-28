import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cv_maker/models/cv_model/cv_model.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:universal_html/html.dart' as html;

Future<html.Blob> myGetBlobPdfContent(BuildContext context, CVModel cvModel) async {
  final imageSvg = await rootBundle.loadString('assets/image/ic_logo_tvf.svg');
  final styles20bold = pw.TextStyle(
    fontSize: 20,
    color: PdfColor.fromInt(0xFF000000),
    font: pw.Font.timesBold(),
  );
  final styles14bold = pw.TextStyle(
    fontSize: 14,
    color: PdfColor.fromInt(0xFF000000),
    font: pw.Font.times(),
  );
  final styles8 = pw.TextStyle(
    fontSize: 8,
    color: PdfColor.fromInt(0xFF000000),
    font: pw.Font.times(),
  );
  final styles12bold = pw.TextStyle(
    fontSize: 12,
    color: PdfColor.fromInt(0xFF000000),
    font: pw.Font.times(),
  );
  final styles16bold = pw.TextStyle(
      fontSize: 16,
      color: PdfColor.fromInt(0xFF000000),
      font: pw.Font.timesBold());
  final pdf = pw.Document();
  pdf.addPage(
    pw.MultiPage(
        build: (pw.Context context) => [
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                  cvModel.name +
                      '${cvModel.gender == ' (Mr.)' ? ' (Mrs.)' : ' (Ms.)'}',
                  style: styles20bold),
              pw.SizedBox(
                height: 6,
              ),
              pw.Text(cvModel.position, style: styles14bold),
              pw.Padding(
                  padding:
                  pw.EdgeInsets.symmetric(horizontal: 35.0, vertical: 16.0),
                  child:
                  pw.Text('Email: ${cvModel.email}', style: styles12bold)),
              cvModel.professionalList.isNotEmpty ? _buildSectionTitlePdf('Professional summary', styles16bold) :pw.Container(),
              cvModel.professionalList.isNotEmpty ?  _buildProfessionalPdf(cvModel) :pw.Container(),
              cvModel.educationList.isNotEmpty  ? _buildSectionTitlePdf('Education', styles16bold) : pw.Container() ,
              cvModel.educationList.isNotEmpty  ? _buildEducationPdf(cvModel) : pw.Container() ,
              cvModel.technicalSummaryList.isNotEmpty ? _buildSectionTitlePdf('Technical Skills', styles16bold) : pw.Container(),
              cvModel.technicalSummaryList.isNotEmpty ? _buildTechnicalSkillsPdf(cvModel) : pw.Container(),
              cvModel.professionalList.isNotEmpty ? _buildSectionTitlePdf('Professional Experience', styles16bold) : pw.Container(),
              cvModel.professionalList.isNotEmpty ? _buildProfessionalExperiencesPdf(cvModel) : pw.Container(),
              cvModel.highLightProjectList.isNotEmpty ? _buildSectionTitlePdf('Highlight Project', styles16bold) : pw.Container(),
              cvModel.highLightProjectList.isNotEmpty ? _buildHighLightProjectsPdf(cvModel) : pw.Container(),
              _buildSectionTitlePdf('Languages', styles16bold) ,
              _buildLanguagePdf(cvModel)
            ],
          ),
        ],
        header: (context) {
          return pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.end,
              children: [
                pw.SvgImage(svg: imageSvg, width: 140, height: 25, fit: pw.BoxFit.cover)
              ]
          );
        },
        footer: (context){
          return pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('TECHVIFY., JSC - CV - Confidential',style: styles8),
                pw.Text('Page ${context.pageNumber} of ${context.pagesCount}',style: styles8)
              ]
          );
        }
    ),
  );
  final bytes = await pdf.save();
  html.Blob blob = html.Blob([bytes], 'application/pdf');
  return blob;
}
@override
Widget build(BuildContext context) {
  return Container();
}

pw.Widget _buildSectionTitlePdf(String title, final styles16bold) {
  return pw.Padding(
    padding: pw.EdgeInsets.symmetric(vertical: 16),
    child: pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(title, style: styles16bold),
        pw.Divider(
          color: PdfColor.fromInt(0xFF000000),
          height: 1,
        )
      ],
    ),
  );
}

pw.Widget _buildProfessionalPdf(CVModel cvModel) {
  return pw.Column(
    children: cvModel.technicalSummaryList
        .map((summary) => _buildProfessionalItemPdf(summary))
        .toList(),
  );
}

pw.Widget _buildProfessionalItemPdf(String summaryItem) {
  return pw.Padding(
    padding: pw.EdgeInsets.symmetric(vertical: 5, horizontal: 35),
    child: pw.Row(
      children: [
        pw.Container(
          height: 8,
          width: 8,
          decoration: pw.BoxDecoration(
              color: PdfColor.fromInt(0xFF000000),
              borderRadius: pw.BorderRadius.circular(5)),
        ),
        pw.SizedBox(width: 16.0),
        pw.Text(
          summaryItem,
          style: pw.TextStyle(
            fontSize: 12,
            color: PdfColor.fromInt(0xFF000000),
            font: pw.Font.times(),
          ),
        )
      ],
    ),
  );
}

pw.Widget _buildEducationPdf(CVModel cvModel) {
  return pw.Column(
    children: cvModel.educationList
        .map((education) => _buildEducationItempdf(education))
        .toList(),
  );
}

pw.Widget _buildEducationItempdf(EducationList education) {
  return pw.Padding(
    padding: pw.EdgeInsets.symmetric(vertical: 4, horizontal: 35),
    child: pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          '${education.schoolNm} - class of ${education.classYear}',
          style: pw.TextStyle(
            fontSize: 12,
            color: PdfColor.fromInt(0xFF000000),
            font: pw.Font.times(),
          ),
        ),
        pw.Padding(
            padding: pw.EdgeInsets.symmetric(vertical: 8.0),
            child: pw.Text(
              'Major: ${education.majorNm}',
              style: pw.TextStyle(
                fontSize: 12,
                color: PdfColor.fromInt(0xFF000000),
                font: pw.Font.times(),
              ),
            ))
      ],
    ),
  );
}

pw.Widget _buildTechnicalSkillsPdf(CVModel cvModel) {
  return pw.Column(
    children: cvModel.skills
        .map((skill) => _buildTechnicalSkillItemPdf(skill))
        .toList(),
  );
}

pw.Widget _buildTechnicalSkillItemPdf(Skills skill) {
  return pw.Padding(
    padding: pw.EdgeInsets.symmetric(vertical: 5, horizontal: 35),
    child: pw.Row(
      // /skill.skillData,
      // '${skill.skillNm}: '
        children: [
          pw.Text(
            '${skill.skillNm} :',
            style: pw.TextStyle(
              fontSize: 12,
              color: PdfColor.fromInt(0xFF000000),
              font: pw.Font.timesBold(),
            ),
          ),
          pw.SizedBox(width: 8.0),
          pw.Text(
            '${skill.skillData} ',
            style: pw.TextStyle(
              fontSize: 12,
              color: PdfColor.fromInt(0xFF000000),
              font: pw.Font.times(),
            ),
          )
        ]),
  );
}

pw.Widget _buildProfessionalExperiencesPdf(CVModel cvModel) {
  return pw.Column(
    children: cvModel.professionalList
        .map((professional) =>
        _buildProfessionalExperienceItemPdf(professional))
        .toList(),
  );
}

pw.Widget _buildProfessionalExperienceItemPdf(ProfessionalList professional) {
  return pw.Padding(
    padding: pw.EdgeInsets.symmetric(vertical: 5, horizontal: 35),
    child: pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(
              '${professional.companyNm}'.toUpperCase(),
              style: pw.TextStyle(
                fontSize: 12,
                color: PdfColor.fromInt(0xFF000000),
                font: pw.Font.timesBold(),
              ),
            ),
            pw.Text(
              '${professional.locationNm} ',
              style: pw.TextStyle(
                fontSize: 12,
                color: PdfColor.fromInt(0xFF000000),
                font: pw.Font.times(),
              ),
            ),
            pw.Text(
              '${professional.startDate} - ${professional.endDate}',
              style: pw.TextStyle(
                fontSize: 12,
                color: PdfColor.fromInt(0xFF000000),
                font: pw.Font.times(),
              ),
            )
          ],
        ),
        pw.SizedBox(height: 8.0),
        pw.Row(children: [
          pw.Text(
            'Role: ',
            style: pw.TextStyle(
              fontSize: 12,
              color: PdfColor.fromInt(0xFF000000),
              font: pw.Font.timesBold(),
            ),
          ),
          pw.Text(
            '${professional.roleNm} ',
            style: pw.TextStyle(
              fontSize: 12,
              color: PdfColor.fromInt(0xFF000000),
              font: pw.Font.times(),
            ),
          )
        ]),
        pw.SizedBox(height: 8.0),
        pw.Text(
          'Responsibilities:',
          style: pw.TextStyle(
            fontSize: 12,
            color: PdfColor.fromInt(0xFF000000),
            font: pw.Font.times(),
          ),
        ),
        pw.SizedBox(
          height: 8.0,
        ),
        pw.Padding(
          padding: pw.EdgeInsets.only(left: 23.0),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: professional.responsibilities
                .map((responsibility) => pw.Bullet(
                text: responsibility,
                style: pw.TextStyle(
                  fontSize: 12,
                  color: PdfColor.fromInt(0xFF000000),
                  font: pw.Font.times(),
                )
            ))
                .toList(),
          ),
        )
      ],
    ),
  );
}

pw.Widget _buildHighLightProjectsPdf(CVModel cvModel) {
  return pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.stretch,
    children: [
      pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.stretch,
        children: cvModel.highLightProjectList
            .map((highLightProject) =>
            _buildHighLightProjectItemPdfT(highLightProject))
            .toList(),
      )
    ],
  );
}

pw.Widget _buildHighLightProjectItemPdfT(
    HighLightProjectList highLightProject) {
  return pw.Container(
    color: PdfColor.fromInt(0xFFFFFFFF),
    padding: pw.EdgeInsets.all(20.0),
    child: pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Padding(
          padding: pw.EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: pw.Text(
            highLightProject.projectNm ?? '',
            style: pw.TextStyle(
              fontSize: 14,
              color: PdfColor.fromInt(0xFF000000),
              font: pw.Font.timesBold(),
            ).copyWith(decoration: pw.TextDecoration.underline),
          ),
        ),
        pw.Table(
          columnWidths: {
            0: pw.FlexColumnWidth(2),
            1: pw.FlexColumnWidth(5),
          },
          border: pw.TableBorder.all(color: PdfColor.fromInt(0xFF000000)),
          children: [
            if(highLightProject.projectDescription.isNotEmpty) _buildTableRowPdf(
                'Project Description', highLightProject.projectDescription),
            if(highLightProject.teamSize.isNotEmpty)  _buildTableRowPdf('Team size', highLightProject.teamSize),
            if(highLightProject.position.isNotEmpty) _buildTableRowPdf('Position', highLightProject.position),
            if(highLightProject.responsibility.isNotEmpty) _buildTableRowPdf('Responsibility',
                _getDataResponsibility(highLightProject.responsibility)),
            if(highLightProject.technologies.isNotEmpty) _buildTableRowPdf('Technology used',
                highLightProject.technologies.join(',').toString()),
            if(highLightProject.communicationused.isNotEmpty) _buildTableRowPdf('Communication used ',
                highLightProject.communicationused),
            if(highLightProject.uiuxdesign.isNotEmpty)  _buildTableRowPdf( 'UI&UX design ',
                highLightProject.uiuxdesign),
            if(highLightProject.documentcontrol.isNotEmpty)  _buildTableRowPdf('Document Control ',
                highLightProject.documentcontrol),
            if(highLightProject.projectmanagementtool.isNotEmpty) _buildTableRowPdf('Project management tool ',
                highLightProject.projectmanagementtool),
          ],
        ),
      ],
    ),
  );
}

String _getDataResponsibility(List<String> responsibilities) {
  String a = '';
  responsibilities.forEach((element) {
    a = a.isEmpty ? '+ $element' : '$a' + '\n+ $element';
  });
  return a;
}

pw.TableRow _buildTableRowPdf(String title, String content) {
  return pw.TableRow(children: [
    pw.Padding(
      padding: pw.EdgeInsets.all(8.0),
      child: pw.Text(title,
          style: pw.TextStyle(
            fontSize: 12,
            color: PdfColor.fromInt(0xFF000000),
            font: pw.Font.times(),
          )),
    ),
    pw.Padding(
      padding: pw.EdgeInsets.all(8.0),
      child: pw.Text(content,
          style: pw.TextStyle(
            fontSize: 12,
            color: PdfColor.fromInt(0xFF000000),
            font: pw.Font.times(),
          )),
    ),
  ]);
}

pw.Widget _buildLanguagePdf(CVModel cvModel) {
  return pw.Column(
    children: cvModel.languages
        .map((language) => _buildLanguageItemPdf(language))
        .toList(),
  );
}



pw.Widget _buildLanguageItemPdf(Languages language) {
  return pw.Padding(
    padding: pw.EdgeInsets.only(left: 35),
    child: pw.Row(
      children: [
        pw.Text('${language.languageNm}:',
            style: pw.TextStyle(
              fontSize: 12,
              color: PdfColor.fromInt(0xFF000000),
              font: pw.Font.timesBold(),
            )),
        pw.SizedBox(width: 10),
        pw.Text(language.level,
            style: pw.TextStyle(
              fontSize: 12,
              color: PdfColor.fromInt(0xFF000000),
              font: pw.Font.times(),
            )),
      ],
    ),
  );
}
Widget _buildAction(BuildContext context, CVModel cvModel) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      TextButton(
        child: Text("Open"),
        onPressed: () async {
          // final url =
          // html.Url.createObjectUrlFromBlob(await myGetBlobPdfContent());
          // html.window.open(url, "_blank");
          // html.Url.revokeObjectUrl(url);
        },
      ),
      SizedBox(width: 30.0),
      TextButton(
        child: Text("Download"),
        onPressed: () async {

        },
      ),
    ],
  );
}

// Handle download pdf
downloadPdf(BuildContext context, CVModel cvModel) async {
  final url =
  html.Url.createObjectUrlFromBlob(await myGetBlobPdfContent(context, cvModel));
  final anchor =
  html.document.createElement('a') as html.AnchorElement
  ..href = url
  ..style.display = 'none'
  ..download = 'CV_TVF_${cvModel.name.replaceAll(' ', '_')}.pdf';
  html.document.body.children.add(anchor);
  anchor.click();
  html.document.body.children.remove(anchor);
  html.Url.revokeObjectUrl(url);
}