import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cv_maker/common/common_style.dart';
import 'package:flutter_cv_maker/common/common_ui.dart';
import 'package:flutter_cv_maker/common/expanded_section.dart';
import 'package:flutter_cv_maker/constants/constants.dart';
import 'package:flutter_cv_maker/models/cv_model/cv_model.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:universal_html/html.dart' as html;

class SectionFive extends StatefulWidget {
  final CVModel cvModel;
  final PageController pageController;
  final Function saveSv;
  final Function update;

  SectionFive({this.cvModel, this.pageController, this.saveSv, this.update});

  @override
  _SectionFiveState createState() => _SectionFiveState();
}

class _SectionFiveState extends State<SectionFive> {
  // FONT 20 BOLD
  // final styles20bold = pw.TextStyle(
  //   fontSize: 20,
  //   color: PdfColor.fromInt(0xFF000000),
  //   font: pw.Font.timesBold(),
  // );

  // FONT 12 BOLD
  // final style12Bold = pw.TextStyle(
  //   fontSize: 12,
  //   color: PdfColor.fromInt(0xFF000000),
  //   font: pw.Font.timesBold(),
  // );

  // FONT 12 REGULAR
  // final styles12regular = pw.TextStyle(
  //   fontSize: 12,
  //   color: PdfColor.fromInt(0xFF000000),
  //   font: pw.Font.times(),
  // );

  // FONT 14 REGULAR
  // final styles14bold = pw.TextStyle(
  //   fontSize: 14,
  //   color: PdfColor.fromInt(0xFF000000),
  //   font: pw.Font.times(),
  // );

  // FONT 8 REGULAR
  // final styles8 = pw.TextStyle(
  //   fontSize: 8,
  //   color: PdfColor.fromInt(0xFF000000),
  //   font: pw.Font.times(),
  // );

  // FONT 16 BOLD
  // final styles16bold = pw.TextStyle(
  //     fontSize: 16,
  //     color: PdfColor.fromInt(0xFF000000),
  //     font: pw.Font.timesBold());

  Future<html.Blob> myGetBlobPdfContent() async {
    final imageSvg =
        await rootBundle.loadString('assets/image/ic_logo_tvf.svg');

    final pdf = pw.Document();
    pdf.addPage(
      pw.MultiPage(
          build: (pw.Context context) => [
                pw.Text(widget.cvModel.name + ' (${widget.cvModel.gender})',
                    style: pw.TextStyle(
                      fontSize: 20,
                      color: PdfColor.fromInt(0xFF000000),
                      font: pw.Font.timesBold(),
                    )),
                pw.SizedBox(
                  height: 6,
                ),
                pw.Text(widget.cvModel.position, style: pw.TextStyle(
                  fontSize: 14,
                  color: PdfColor.fromInt(0xFF000000),
                  font: pw.Font.times(),
                )),
                 widget.cvModel.email.isNotEmpty ?   pw.Padding(
                     padding: pw.EdgeInsets.symmetric(
                         horizontal: 35.0, vertical: 16.0),
                     child: pw.Text('Email: ${widget.cvModel.email}',
                         style: pw.TextStyle(
                           fontSize: 12,
                           color: PdfColor.fromInt(0xFF000000),
                           font: pw.Font.times(),
                         ))) :pw.Container(),
                widget.cvModel.professionalList.isNotEmpty
                    ? _buildSectionTitlePdf(
                        'Professional summary', pw.TextStyle(
                    fontSize: 16,
                    color: PdfColor.fromInt(0xFF000000),
                    font: pw.Font.timesBold()))
                    : pw.Container(),
                widget.cvModel.professionalList.isNotEmpty
                    ? _buildProfessionalPdf()
                    : pw.Container(),
                widget.cvModel.educationList.isNotEmpty
                    ? _buildSectionTitlePdf('Education', pw.TextStyle(
                    fontSize: 16,
                    color: PdfColor.fromInt(0xFF000000),
                    font: pw.Font.timesBold()))
                    : pw.Container(),
                widget.cvModel.educationList.isNotEmpty
                    ? _buildEducationPdf()
                    : pw.Container(),
                widget.cvModel.technicalSummaryList.isNotEmpty
                    ? _buildSectionTitlePdf('Technical Skills', pw.TextStyle(
                    fontSize: 16,
                    color: PdfColor.fromInt(0xFF000000),
                    font: pw.Font.timesBold()))
                    : pw.Container(),
                widget.cvModel.technicalSummaryList.isNotEmpty
                    ? _buildTechnicalSkillsPdf()
                    : pw.Container(),
                widget.cvModel.professionalList.isNotEmpty
                    ? _buildSectionTitlePdf(
                        'Professional Experience', pw.TextStyle(
                    fontSize: 16,
                    color: PdfColor.fromInt(0xFF000000),
                    font: pw.Font.timesBold()))
                    : pw.Container(),
                widget.cvModel.professionalList.isNotEmpty
                    ? _buildProfessionalExperiencesPdf()
                    : pw.Container(),
                widget.cvModel.certificateList.isNotEmpty
                    ? _buildSectionTitlePdf('Certificates', pw.TextStyle(
                    fontSize: 16,
                    color: PdfColor.fromInt(0xFF000000),
                    font: pw.Font.timesBold()))
                    : pw.Container(),
                widget.cvModel.certificateList.isNotEmpty
                    ? _buildCertificatesPdf()
                    : pw.Container(),
                widget.cvModel.highLightProjectList.isNotEmpty
                    ? _buildHighLightProjectsPdf()
                    : pw.Container(),
                _buildSectionTitlePdf('Languages', pw.TextStyle(
                    fontSize: 16,
                    color: PdfColor.fromInt(0xFF000000),
                    font: pw.Font.timesBold())),
                _buildLanguagePdf()
              ],
          header: (context) {
            return pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children: [
                  pw.SvgImage(
                      svg: imageSvg,
                      width: 140,
                      height: 25,
                      fit: pw.BoxFit.cover)
                ]);
          },
          footer: (context) {
            return pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('TECHVIFY., JSC - CV - Confidential', style: pw.TextStyle(
                    fontSize: 8,
                    color: PdfColor.fromInt(0xFF000000),
                    font: pw.Font.times(),
                  )),
                  pw.Text('Page ${context.pageNumber} of ${context.pagesCount}',
                      style: pw.TextStyle(
                        fontSize: 8,
                        color: PdfColor.fromInt(0xFF000000),
                        font: pw.Font.times(),
                      ))
                ]);
          }),
    );
    final bytes = await pdf.save();
    html.Blob blob = html.Blob([bytes], 'application/pdf');
    return blob;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // myGetBlobPdfContent();
    return Scaffold(
      body: Container(
          child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [_buildPdfFile(context), _buildAction(context)],
        ),
      )),
    );
  }

  /////////////////////////
  //// BUILD PDF FILE /////
  ////////////////////////

  pw.Widget _buildProfessionalExperiencesPdf() {
    return pw.Column(
      children: widget.cvModel.professionalList
          .map((professional) =>
              _buildProfessionalExperienceItemPdf(professional))
          .toList(),
    );
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

  pw.Widget _buildProfessionalPdf() {
    return pw.Column(
      children: widget.cvModel.technicalSummaryList
          .map((summary) => _buildProfessionalItemPdf(summary))
          .toList(),
    );
  }

  pw.Widget _buildProfessionalItemPdf(String summaryItem) {
    return pw.Padding(
      padding: pw.EdgeInsets.symmetric(vertical: 5, horizontal: 35),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
     pw.Padding(
       padding: pw.EdgeInsets.only(top: 5),
       child: pw.Container(

         height: 5,
         width: 5,
         decoration: pw.BoxDecoration(
           color: PdfColor.fromInt(0xFF000000),
           shape: pw.BoxShape.circle,
         ),
       ),
     ),
          pw.SizedBox(width: 16.0),
          pw.Flexible(
            child:
            pw.Text(
              summaryItem,
              style: pw.TextStyle(
                fontSize: 12,
                color: PdfColor.fromInt(0xFF000000),
                font: pw.Font.times(),
              ),
            )
          )
        ],
      ),
    );
  }

  pw.Widget _buildEducationPdf() {
    return pw.Column(
      children: widget.cvModel.educationList
          .map((education) => _buildEducationItemPdf(education))
          .toList(),
    );
  }

  pw.Widget _buildEducationItemPdf(EducationList education) {
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
            ),
          ]),
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
              pw.Expanded(
                flex: 2,
                child:pw.Text(
                  '${professional.companyNm}'.toUpperCase(),textAlign: pw.TextAlign.left,
                  style: pw.TextStyle(
                    fontSize: 12,
                    color: PdfColor.fromInt(0xFF000000),
                    font: pw.Font.timesBold(),
                  ),
                ),
              ),
           pw.Expanded(
             flex: 1,
             child:     pw.Text(
               '${professional.locationNm} ',textAlign: pw.TextAlign.center,
               style: pw.TextStyle(
                 fontSize: 12,
                 color: PdfColor.fromInt(0xFF000000),
                 font: pw.Font.times(),
               ),
             ),
           ),
            pw.Expanded(
              flex: 2,
              child:  pw.Text(
                '${professional.startDate} - ${professional.endDate}',textAlign: pw.TextAlign.center,
                style: pw.TextStyle(
                  fontSize: 12,
                  color: PdfColor.fromInt(0xFF000000),
                  font: pw.Font.times(),
                ),
              )
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
                      )))
                  .toList(),
            ),
          )
        ],
      ),
    );
  }

  pw.Widget _buildTechnicalSkillsPdf() {
    return pw.Column(
      children: widget.cvModel.skills
          .map((skill) => _buildTechnicalSkillItemPdf(skill))
          .toList(),
    );
  }

  pw.Widget _buildHighLightProjectsPdf() {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.stretch,
      children: widget.cvModel.highLightProjectList
          .map((highLightProject) =>
              _buildHighLightProjectItemPdfT(highLightProject))
          .toList(),
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
              0: pw.FlexColumnWidth(3),
              1: pw.FlexColumnWidth(6),
            },
            border: pw.TableBorder.all(
                color: PdfColor.fromInt(0xFF000000), width: 0.5),
            children: [
              if (highLightProject.projectDescription.isNotEmpty)
                _buildTableRowPdf(
                    'Project Description', highLightProject.projectDescription),
              if (highLightProject.teamSize.isNotEmpty)
                _buildTableRowPdf('Team size', highLightProject.teamSize),
              if (highLightProject.position.isNotEmpty)
                _buildTableRowPdf('Position', highLightProject.position),
              if (highLightProject.responsibility.isNotEmpty)
                _buildTableRowPdf('Responsibility',
                    _getDataResponsibility(highLightProject.responsibility)),
              if (highLightProject.technologies.isNotEmpty)
                _buildTableRowPdf('Technology used',
                    highLightProject.technologies.join(',').toString()),
              if (highLightProject.communicationused.isNotEmpty)
                _buildTableRowPdf(
                    'Communication used ', highLightProject.communicationused),
              if (highLightProject.uiuxdesign.isNotEmpty)
                _buildTableRowPdf('UI&UX design ', highLightProject.uiuxdesign),
              if (highLightProject.documentcontrol.isNotEmpty)
                _buildTableRowPdf(
                    'Document Control ', highLightProject.documentcontrol),
              if (highLightProject.projectmanagementtool.isNotEmpty)
                _buildTableRowPdf('Project management tool ',
                    highLightProject.projectmanagementtool),
            ],
          ),
        ],
      ),
    );
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

  pw.Widget _buildLanguagePdf() {
    return pw.Column(
      children: widget.cvModel.languages
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

  pw.Widget _buildCertificatesPdf() {
    return pw.Padding(
        padding: pw.EdgeInsets.only(left: 35),
        child: pw.Column(
          children: [
            pw.Column(
              children: List.generate(
                  widget.cvModel.certificateList.length,
                  (index) => pw.Row(
                        children: [
                          pw.Expanded(
                            child: pw.Text(
                                widget.cvModel.certificateList[index]
                                    .certificateNm,
                                style: pw.TextStyle(
                                  fontSize: 12,
                                  color: PdfColor.fromInt(0xFF000000),
                                  font: pw.Font.times(),
                                )),
                          ),
                          pw.Text(
                              widget.cvModel.certificateList[index]
                                  .certificateYear,
                              style: pw.TextStyle(
                                fontSize: 12,
                                color: PdfColor.fromInt(0xFF000000),
                                font: pw.Font.times(),
                              ))
                        ],
                      )),
            )
          ],
        ));
  }

  ////////////////////////////////////////
  //// BUILD PDF VIEW WIDGETS ON WEB ////
  ///////////////////////////////////////
  Widget _buildPdfFile(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: w * 0.05),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 20,
          ),
          Text(
            widget.cvModel.name + '(${widget.cvModel.gender})',
            style: CommonStyle.size20W700black(context),
          ),
          SizedBox(
            height: 6,
          ),
          Text(
            widget.cvModel.position,
            style: CommonStyle.size14W500black(context),
          ),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 35.0, vertical: 16.0),
              child: Text('Email: ${widget.cvModel.email}',
                  style: CommonStyle.size12W400black(context))),
          widget.cvModel.technicalSummaryList.isNotEmpty
              ? _buildSectionTitle(context, 'Professional summary')
              : Container(),
          _buildProfessional(context),
          widget.cvModel.educationList.isNotEmpty
              ? _buildSectionTitle(context, 'Education')
              : Container(),
          widget.cvModel.educationList.isNotEmpty
              ? _buildEducation(context)
              : Container(),
          widget.cvModel.technicalSummaryList.isNotEmpty
              ? _buildSectionTitle(context, 'Technical Skills')
              : Container(),
          widget.cvModel.technicalSummaryList.isNotEmpty
              ? _buildTechnicalSkills(context)
              : Container(),
          widget.cvModel.professionalList.isNotEmpty
              ? _buildSectionTitle(context, 'Professional Experience')
              : Container(),
          widget.cvModel.professionalList.isNotEmpty
              ? _buildProfessionalExperiences(context)
              : Container(),
          widget.cvModel.certificateList.isNotEmpty
              ? _buildCertificates(context)
              : Container(),
          widget.cvModel.highLightProjectList.isNotEmpty
              ? _buildHighLightProjects(context)
              : Container(),
          _buildSectionTitle(context, 'Languages'),
          _buildLanguage(context)
        ],
      ),
    );
  }

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
            final anchor = html.document.createElement('a')
                as html.AnchorElement
              ..href = url
              ..style.display = 'none'
              ..download =
                  'CV_TVF_${widget.cvModel.name.replaceAll(' ', '_')}.pdf';
            html.document.body.children.add(anchor);
            anchor.click();
            html.document.body.children.remove(anchor);
            html.Url.revokeObjectUrl(url);
          },
        ),
      ],
    );
  }

  Widget _buildProfessional(BuildContext context) {
    return Column(
      children: widget.cvModel.technicalSummaryList
          .map((summary) => Bullet(
                text: summary,
              ))
          .toList(),
    );
  }

  Widget _buildEducation(BuildContext context) {
    return Column(
      children: widget.cvModel.educationList
          .map((education) => _buildEducationItem(context, education))
          .toList(),
    );
  }

  Widget _buildEducationItem(BuildContext context, EducationList education) {
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

  Widget _buildTechnicalSkills(BuildContext context) {
    return Column(
      children: widget.cvModel.skills
          .map((skill) => _buildTechnicalSkillItem(context, skill))
          .toList(),
    );
  }

  Widget _buildTechnicalSkillItem(BuildContext context, Skills skill) {
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

  Widget _buildProfessionalExperiences(BuildContext context) {
    return Column(
      children: widget.cvModel.professionalList
          .map((professional) =>
              _buildProfessionalExperienceItem(context, professional))
          .toList(),
    );
  }

  Widget _buildProfessionalExperienceItem(
      BuildContext context, ProfessionalList professional) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 35),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
           Expanded(
             flex: 2,
             child:Text('${professional.companyNm}, ', style: CommonStyle.size12W400black(context).copyWith(fontWeight: FontWeight.w700,fontSize: 24),textAlign: TextAlign.start,),
             ),
           Expanded(
             flex: 1,
             child:Text('${professional.locationNm}, ', style: CommonStyle.size12W400black(context),textAlign: TextAlign.center,),
             ),
              Expanded(
                flex: 2,
                child: Text(
                  '${professional.startDate} - ${professional.endDate}',
                  style: CommonStyle.size12W400black(context),textAlign: TextAlign.end,
                ),
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

  Widget _buildCertificates(context) {
    return Column(
      children: [
        _buildSectionTitle(context, 'Certificates'),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 35),
          child: Column(
            children: List.generate(
                widget.cvModel.certificateList.length,
                (index) => Row(
                      children: [
                        Expanded(
                          child: Text(
                              widget
                                  .cvModel.certificateList[index].certificateNm,
                              style: CommonStyle.size12W400black(context)),
                        ),
                        Text(
                            widget
                                .cvModel.certificateList[index].certificateYear,
                            style: CommonStyle.size12W400black(context))
                      ],
                    )),
          ),
        )
      ],
    );
  }

  Widget _buildHighLightProjects(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildSectionTitle(context, 'Highlight Project'),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: widget.cvModel.highLightProjectList
              .map((highLightProject) =>
                  _buildHighLightProjectItem(context, highLightProject))
              .toList(),
        )
      ],
    );
  }

  Widget _buildHighLightProjectItem(
      BuildContext context, HighLightProjectList highLightProject) {
    return Container(
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
              0: FlexColumnWidth(3),
              1: FlexColumnWidth(6),
            },
            border: TableBorder.all(color: Colors.black),
            children: [
              if (highLightProject.projectDescription.isNotEmpty)
                _buildTableRow(context, 'Project Description',
                    highLightProject.projectDescription),
              if (highLightProject.teamSize.isNotEmpty)
                _buildTableRow(context, 'Team size', highLightProject.teamSize),
              if (highLightProject.position.isNotEmpty)
                _buildTableRow(context, 'Position', highLightProject.position),
              if (highLightProject.responsibility.isNotEmpty)
                _buildTableRow(context, 'Responsibility',
                    _getDataResponsibility(highLightProject.responsibility)),
              if (highLightProject.technologies.isNotEmpty)
                _buildTableRow(context, 'Technology used',
                    highLightProject.technologies.join(', ').toString()),
              if (highLightProject.communicationused.isNotEmpty)
                _buildTableRow(context, 'Communication used ',
                    highLightProject.communicationused),
              if (highLightProject.uiuxdesign.isNotEmpty)
                _buildTableRow(
                    context, 'UI&UX design ', highLightProject.uiuxdesign),
              if (highLightProject.documentcontrol.isNotEmpty)
                _buildTableRow(context, 'Document Control ',
                    highLightProject.documentcontrol),
              if (highLightProject.projectmanagementtool.isNotEmpty)
                _buildTableRow(context, 'Project management tool ',
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

  TableRow _buildTableRow(BuildContext context, String title, String content) {
    return TableRow(children: [
      Padding(
        padding: EdgeInsets.all(8.0),
        child:
            Text(title ?? kEmpty, style: CommonStyle.size12W400black(context)),
      ),
      Padding(
        padding: EdgeInsets.all(8.0),
        child: Text(content ?? kEmpty,
            style: CommonStyle.size12W400black(context)),
      ),
    ]);
  }

  Widget _buildLanguage(BuildContext context) {
    return Column(
      children: widget.cvModel.languages
          .map((language) => _buildLanguageItem(context, language))
          .toList(),
    );
  }

  Widget _buildLanguageItem(BuildContext context, Languages language) {
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
}
