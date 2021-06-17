
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cv_maker/common/common_style.dart';
import 'package:flutter_cv_maker/common/common_ui.dart';
import 'package:flutter_cv_maker/models/cv_model/cv_model.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:universal_html/html.dart' as html;

class SectionFive extends StatelessWidget {
  final CVModel cvModel;
  final PageController pageController;

  SectionFive({this.cvModel, this.pageController});

  Future<html.Blob> myGetBlobPdfContent() async {
    final styles20bold =pw.TextStyle(fontSize: 20,color:PdfColor.fromInt(0xFF000000),font:pw.Font.timesBold(),);
    final styles14bold =pw.TextStyle(fontSize: 14,color:PdfColor.fromInt(0xFF000000),font:pw.Font.times(),);
    final styles12bold =pw.TextStyle(fontSize: 12,color:PdfColor.fromInt(0xFF000000),font:pw.Font.times(),);
    final styles16bold =pw.TextStyle(fontSize: 16,color:PdfColor.fromInt(0xFF000000),font:pw.Font.timesBold());
    final pdf = pw.Document();
    pdf.addPage(
      pw.MultiPage(
        build: (pw.Context context) => [
          pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  cvModel.name + '${cvModel.gender == 'Male' ? ' (Mr.)' : ' (Mrs.)'}',
                 style: styles20bold
                ),
                pw.SizedBox(
                  height: 6,
                ),
                pw.Text(
                  cvModel.position,
                  style:styles14bold
                ),
                pw.Padding(
                    padding: pw.EdgeInsets.symmetric(horizontal: 35.0, vertical: 16.0),
                    child: pw.Text('Email: ${cvModel.email}',
                        style:styles12bold
                    )),
                _buildSectionTitlePdf('Professional summary',styles16bold),
                _buildProfessionalPdf(),
                _buildSectionTitlePdf('Education',styles16bold),
                _buildEducationPdf(),
                _buildSectionTitlePdf('Technical Skills',styles16bold),
                _buildTechnicalSkillsPdf(),
                _buildSectionTitlePdf('Professional Experience',styles16bold),
                _buildProfessionalExperiencesPdf(),
                _buildSectionTitlePdf('HighLight Project',styles16bold),
                _buildHighLightProjectsPdf(),
                _buildSectionTitlePdf('Languages',styles16bold),
                _buildLanguagePdf()
              ],
            ),

        ],
      ),
    );
    final bytes = await pdf.save();
    html.Blob blob = html.Blob([bytes], 'application/pdf');
    return blob;
  }

  @override
  Widget build(BuildContext context) {
    //myGetBlobPdfContent();
    return Scaffold(
      body: Container(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            _buildPdfFile(context),
             _buildAction(context)
          ],
        ),
      )),
    );
  }

  Widget _buildPdfFile(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: w * 0.1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            cvModel.name + '${cvModel.gender == 'Male' ? ' (Mr.)' : ' (Mrs.)'}',
            style: CommonStyle.size20W700black(context),
          ),
          SizedBox(
            height: 6,
          ),
          Text(
            cvModel.position,
            style: CommonStyle.size14W500black(context),
          ),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 35.0, vertical: 16.0),
              child: Text('Email: ${cvModel.email}',
                  style: CommonStyle.size12W400black(context))),
          _buildSectionTitle(context, 'Professional summary'),
          _buildProfessional(context),
          _buildSectionTitle(context, 'Education'),
          _buildEducation(context),
          _buildSectionTitle(context, 'Technical Skills'),
          _buildTechnicalSkills(context),
          _buildSectionTitle(context, 'Professional Experience'),
          _buildProfessionalExperiences(context),
          _buildHighLightProjects(context),
          _buildSectionTitle(context, 'Languages'),
          _buildLanguage(context)
        ],
      ),
    );
  }

  // Build section title
  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: CommonStyle.size16W700black(context)),
          Divider(
            color: Colors.black,
            height: 1,
          )
        ],
      ),
    );
  }

  //buidl section title Pdf
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

  Widget _buildAction(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        TextButton(
          child: Text("Open"),
          onPressed: () async {
            final url =
                html.Url.createObjectUrlFromBlob(await myGetBlobPdfContent());
            html.window.open(url, "_blank");
            html.Url.revokeObjectUrl(url);
          },
        ),
        SizedBox(width: 30.0),
        TextButton(
          child: Text("Download"),
          onPressed: () async {
            final url =
                html.Url.createObjectUrlFromBlob(await myGetBlobPdfContent());
            final anchor =
                html.document.createElement('a') as html.AnchorElement
                  ..href = url
                  ..style.display = 'none'
                  ..download = 'some_name.pdf';
            html.document.body.children.add(anchor);
            anchor.click();
            html.document.body.children.remove(anchor);
            html.Url.revokeObjectUrl(url);
          },
        ),
      ],
    );
  }

  // Create Professional list
  Widget _buildProfessional(BuildContext context) {
    return Column(
      children: cvModel.technicalSummaryList
          .map((summary) => _buildProfessionalItem(context, summary))
          .toList(),
    );
  }

  //create Professional list pdf
  pw.Widget _buildProfessionalPdf() {
    return pw.Column(
      children: cvModel.technicalSummaryList
          .map((summary) => _buildProfessionalItemPdf(summary)).toList(),
    );
  }

  // Create Professional item
  Widget _buildProfessionalItem(BuildContext context, String summaryItem) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 35),
      child: Row(
        children: [
          Icon(
            Icons.circle,
            color: Colors.black,
            size: 8,
          ),
          SizedBox(width: 16.0),
          Text(
            summaryItem,
            style: CommonStyle.size12W400black(context),
          )
        ],
      ),
    );
  }
  // Create Professional item pdf
  pw.Widget _buildProfessionalItemPdf(String summaryItem) {
    return pw.Padding(
      padding: pw.EdgeInsets.symmetric(vertical: 5, horizontal: 35),
      child: pw.Row(
        children: [
          // pw.Icon(
          //   Icons.circle,
          //   color: PdfColor.fromInt(0xFF000000),
          //   size: 8,
          // ),
          pw.Container(
            height: 8,
            width: 8,
            decoration:pw.BoxDecoration(
                color: PdfColor.fromInt(0xFF000000),
              borderRadius: pw.BorderRadius.circular(5)
            ),

          ),
          pw.SizedBox(width: 16.0),
          pw.Text(
            summaryItem,
            style: pw.TextStyle(fontSize: 12,color:PdfColor.fromInt(0xFF000000),font:pw.Font.times(),),
          )
        ],
      ),
    );
  }

  // Build Education list
  Widget _buildEducation(BuildContext context) {
    return Column(
      children: cvModel.educationList
          .map((education) => _buildEducationItem(context, education))
          .toList(),
    );
  }
  // Build Education list pdf
  pw.Widget _buildEducationPdf() {
    return pw.Column(
      children: cvModel.educationList
          .map((education) => _buildEducationItempdf(education))
          .toList(),
    );
  }

  // Build Education item
  Widget _buildEducationItem(BuildContext context, Education education) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 35),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${education.schoolNm} - class of ${education.classYear}',
            style: CommonStyle.size12W400black(context),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Text('Major: ${education.majorNm}',
                style: CommonStyle.size12W400black(context)),
          )
        ],
      ),
    );
  }
  // Build Education item pdf
  pw.Widget _buildEducationItempdf(Education education) {
    return pw.Padding(
      padding: pw.EdgeInsets.symmetric(vertical: 4, horizontal: 35),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            '${education.schoolNm} - class of ${education.classYear}',
            style:pw.TextStyle(fontSize: 12,color:PdfColor.fromInt(0xFF000000),font:pw.Font.times(),),
          ),
          pw.Padding(
            padding: pw.EdgeInsets.symmetric(vertical: 8.0),
            child: pw.Text('Major: ${education.majorNm}',
                style:pw.TextStyle(fontSize: 12,color:PdfColor.fromInt(0xFF000000),font:pw.Font.times(),),
          )
          )
        ],
      ),
    );
  }

  // Build Technical skill list
  Widget _buildTechnicalSkills(BuildContext context) {
    return Column(
      children: cvModel.skills
          .map((skill) => _buildTechnicalSkillItem(context, skill))
          .toList(),
    );
  }
  // Build Technical skill list pdf
  pw.Widget _buildTechnicalSkillsPdf() {
    return pw.Column(
      children: cvModel.skills
          .map((skill) => _buildTechnicalSkillItemPdf(skill))
          .toList(),
    );
  }

  // Build Technical skill item
  Widget _buildTechnicalSkillItem(BuildContext context, Skill skill) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 35),
      child: Row(
        children: [
          Text.rich(TextSpan(children: [
            TextSpan(
                text: '${skill.skillNm}: ',
                style: CommonStyle.size12W700black(context)),
            TextSpan(
                text: skill.skillData,
                style: CommonStyle.size12W400black(context)),
          ]))
        ],
      ),
    );
  }
  // Build Technical skill item pdf
  pw.Widget _buildTechnicalSkillItemPdf(Skill skill) {
    return  pw.Padding(
      padding:  pw.EdgeInsets.symmetric(vertical: 5, horizontal: 35),
      child:  pw.Row(
      // /skill.skillData,
     // '${skill.skillNm}: '
     children: [
         pw.Text('${skill.skillNm} :', style:pw.TextStyle(fontSize: 12,color:PdfColor.fromInt(0xFF000000),font:pw.Font.timesBold(),), ),
         pw.SizedBox(width: 8.0),
         pw.Text('${skill.skillData} ', style:pw.TextStyle(fontSize: 12,color:PdfColor.fromInt(0xFF000000),font:pw.Font.times(),), )
          ]
      ),
    );
  }

  // Build Professional Experience list
  Widget _buildProfessionalExperiences(BuildContext context) {
    return Column(
      children: cvModel.professionalList
          .map((professional) =>
              _buildProfessionalExperienceItem(context, professional))
          .toList(),
    );
  }
  // Build Professional Experience list pdf
  pw.Widget _buildProfessionalExperiencesPdf() {
    return pw.Column(
      children: cvModel.professionalList
          .map((professional) =>
          _buildProfessionalExperienceItemPdf(professional))
          .toList(),
    );
  }

  // Build Professional Experience item
  Widget _buildProfessionalExperienceItem(
      BuildContext context, Professional professional) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 35),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              RichTextCommon(
                boldText: '${professional.companyNm}, ',
                regularText: professional.locationNm,
                size: 14,
              ),
              Spacer(),
              Text(
                '${professional.startDate} - ${professional.endDate}',
                style: CommonStyle.size12W400black(context),
              )
            ],
          ),
          SizedBox(height: 8.0),
          RichTextCommon(
            boldText: 'Role: ',
            regularText: professional.roleNm,
          ),
          SizedBox(height: 8.0),
          Text(
            'Responsibilities:',
            style: CommonStyle.size12W700black(context),
          ),
          Row(
            children: [
              Icon(
                Icons.circle,
                color: Colors.black,
                size: 8,
              ),
              SizedBox(width: 16.0),
              Text(
                'Participate in various software development phase such as:',
                style: CommonStyle.size12W400black(context),
              )
            ],
          ),
          SizedBox(
            height: 8.0,
          ),
          Padding(
            padding: EdgeInsets.only(left: 23.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: professional.responsibilities
                  .map((responsibility) => Bullet(
                        text: responsibility,
                        isFill: false,
                      ))
                  .toList(),
            ),
          )
        ],
      ),
    );
  }
  // Build Professional Experience item pdf
  pw.Widget _buildProfessionalExperienceItemPdf(Professional professional) {
    return  pw.Padding(
      padding:  pw.EdgeInsets.symmetric(vertical: 5, horizontal: 35),
      child:  pw.Column(
        crossAxisAlignment:  pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            children: [
              pw.Row(
                  children: [
                    pw.Text('${professional.companyNm}, ', style:pw.TextStyle(fontSize: 12,color:PdfColor.fromInt(0xFF000000),font:pw.Font.timesBold(),), ),
                    pw.SizedBox(width: 14.0),
                    pw.Text('${ professional.locationNm} ', style:pw.TextStyle(fontSize: 12,color:PdfColor.fromInt(0xFF000000),font:pw.Font.times(),), )
                  ]
              ),
              pw.Spacer(),
              pw.Text(
                '${professional.startDate} - ${professional.endDate}',
                style:pw.TextStyle(fontSize: 12,color:PdfColor.fromInt(0xFF000000),font:pw.Font.times(),),
              )
            ],
          ),
          pw.SizedBox(height: 8.0),
          pw.Row(
              children: [
                pw.Text('Role:  ', style:pw.TextStyle(fontSize: 12,color:PdfColor.fromInt(0xFF000000),font:pw.Font.timesBold(),), ),
                pw.SizedBox(width: 14.0),
                pw.Text('${professional.roleNm} ', style:pw.TextStyle(fontSize: 12,color:PdfColor.fromInt(0xFF000000),font:pw.Font.times(),), )
              ]
          ),
          pw.SizedBox(height: 8.0),
          pw.Text(
            'Responsibilities:',
            style:pw.TextStyle(fontSize: 12,color:PdfColor.fromInt(0xFF000000),font:pw.Font.times(),),
          ),
          pw.Row(
            children: [
              pw.Container(
                height: 8,
                width: 8,
                decoration:pw.BoxDecoration(
                    color: PdfColor.fromInt(0xFF000000),
                    borderRadius: pw.BorderRadius.circular(5)
                ),

              ),
              pw.SizedBox(width: 16.0),
              pw.Text(
                'Participate in various software development phase such as:',
                style:pw.TextStyle(fontSize: 12,color:PdfColor.fromInt(0xFF000000),font:pw.Font.times(),),
              )
            ],
          ),
          pw.SizedBox(
            height: 8.0,
          ),
          pw.Padding(
            padding:  pw.EdgeInsets.only(left: 23.0),
            child:pw.Column(
              crossAxisAlignment:pw.CrossAxisAlignment.start,
              children: professional.responsibilities
                  .map((responsibility) =>  pw.Bullet(
                        text: responsibility,
                      ))
                  .toList(),
            ),
          )
        ],
      ),
    );
  }

  // Build highlight project list
  Widget _buildHighLightProjects(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildSectionTitle(context, 'HighLight Project'),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: cvModel.highLightProjectList
              .map((highLightProject) =>
                  _buildHighLightProjectItem(context, highLightProject))
              .toList(),
        )
      ],
    );
  }
  // Build highlight project list pdf
  pw.Widget _buildHighLightProjectsPdf() {
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

  // Build highlight project item
  Widget _buildHighLightProjectItem(
      BuildContext context, HighLightProject highLightProject) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Text(
              highLightProject.projectNm ?? '',
              style: CommonStyle.size14W700black(context)
                  .copyWith(decoration: TextDecoration.underline),
            ),
          ),
          Table(
            columnWidths: {
              0: FlexColumnWidth(1),
              1: FlexColumnWidth(4),
            },
            border: TableBorder.all(color: Colors.black),
            children: [
              _buildTableRow(context, 'Project Description',
                  highLightProject.projectDescription),
              _buildTableRow(context, 'Team size', highLightProject.teamSize),
              _buildTableRow(context, 'Position', highLightProject.position),
              _buildTableRow(context, 'Responsibility',
                  _getDataResponsibility(highLightProject.responsibility)),
              _buildTableRow(context, 'Technology used',
                  highLightProject.technologies.join(', ').toString()),
            ],
          ),
        ],
      ),
    );
  }
  // Build highlight project item
  pw.Widget _buildHighLightProjectItemPdfT(HighLightProject highLightProject) {
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
              style: pw.TextStyle(fontSize: 14,color:PdfColor.fromInt(0xFF000000),font:pw.Font.timesBold(),)
                  .copyWith(decoration: pw.TextDecoration.underline),
            ),
          ),
          pw.Table(
            columnWidths: {
              0: pw.FlexColumnWidth(2),
              1: pw.FlexColumnWidth(5),
            },
            border: pw.TableBorder.all(color:PdfColor.fromInt(0xFF000000)),
            children: [
              _buildTableRowPdf('Project Description',highLightProject.projectDescription),
              _buildTableRowPdf( 'Team size', highLightProject.teamSize),
              _buildTableRowPdf('Position', highLightProject.position),
               _buildTableRowPdf('Responsibility',_getDataResponsibility(highLightProject.responsibility)),
               _buildTableRowPdf('Technology used',highLightProject.technologies.join(',').toString()),
            ],
          ),
        ],
      ),
    );
  }

  // Get data for responsibility
  String _getDataResponsibility(List<String> responsibilities) {
    String a = '';
    responsibilities.forEach((element) {
      a = a.isEmpty ? '+ $element' : '$a' + '\n+ $element';
    });
    return a;
  }

  // Build table row
  TableRow _buildTableRow(BuildContext context, String title, String content) {
    return TableRow(children: [
      Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(title, style: CommonStyle.size12W400black(context)),
      ),
      Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(content, style: CommonStyle.size12W400black(context)),
      ),
    ]);
  }
  // Build table row
  pw.TableRow _buildTableRowPdf(String title, String content) {
    return pw.TableRow(children: [
      pw.Padding(
        padding: pw.EdgeInsets.all(16.0),
        child: pw.Text(title, style:pw.TextStyle(fontSize: 12,color:PdfColor.fromInt(0xFF000000),font:pw.Font.times(),)),
      ),
      pw.Padding(
        padding: pw.EdgeInsets.all(16.0),
        child: pw.Text(content, style:pw.TextStyle(fontSize: 12,color:PdfColor.fromInt(0xFF000000),font:pw.Font.times(),)),
      ),
    ]);
  }
  //Build custom table

  // Build language project
  Widget _buildLanguage(BuildContext context) {
    return Column(
      children: cvModel.languages
          .map((language) => _buildLanguageItem(context, language))
          .toList(),
    );
  }
  // Build language project pdf
  pw.Widget _buildLanguagePdf() {
    return pw.Column(
      children: cvModel.languages
          .map((language) => _buildLanguageItemPdf(language))
          .toList(),
    );
  }

  // Build language project item
  Widget _buildLanguageItem(BuildContext context, Language language) {
    return Padding(
      padding: EdgeInsets.only(left: 35),
      child: Row(
        children: [
          Text('${language.languageNm}:',
              style: CommonStyle.size12W700black(context)),
          SizedBox(width: 10),
          Text(language.level, style: CommonStyle.size12W400black(context)),
        ],
      ),
    );
  }
  // Build language project item pdf
  pw.Widget _buildLanguageItemPdf(Language language) {
    return   pw.Padding(
      padding:   pw.EdgeInsets.only(left: 35),
      child:   pw.Row(
        children: [
      pw.Text('${language.languageNm}:',
              style: pw.TextStyle(fontSize: 12,color:PdfColor.fromInt(0xFF000000),font:pw.Font.timesBold(),)),
        pw.SizedBox(width: 10),
          pw.Text(language.level, style:pw.TextStyle(fontSize: 12,color:PdfColor.fromInt(0xFF000000),font:pw.Font.times(),)),
        ],
      ),
    );
  }
}
