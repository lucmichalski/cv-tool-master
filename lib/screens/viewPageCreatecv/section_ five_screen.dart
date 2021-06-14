import 'package:flutter/material.dart';
import 'package:flutter_cv_maker/common/common_style.dart';
import 'package:flutter_cv_maker/common/common_ui.dart';
import 'package:flutter_cv_maker/models/cv_model/cv_model.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:universal_html/html.dart' as html;

class SectionFive extends StatelessWidget {
  final CVModel cvModel;
  final PageController pageController;

  const SectionFive({this.cvModel, this.pageController});

  Future<html.Blob> myGetBlobPdfContent() async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.MultiPage(
        build: (pw.Context context) => [
          pw.Column(
            children: List<pw.Widget>.generate(
              150,
              (int index) {
                return pw.Text('index: $index');
              },
            ),
          )
        ],
      ),
    );
    final bytes = await pdf.save();
    html.Blob blob = html.Blob([bytes], 'application/pdf');
    return blob;
  }

  @override
  Widget build(BuildContext context) {
    myGetBlobPdfContent();
    return Scaffold(
      body: Container(
          child: Column(
        children: [
          _buildPdfFile(context),
          // _buildAction(context)
        ],
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
          Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: Text('Professional summary',
                style: CommonStyle.size20W700black(context)),
          ),
          _buildProfessional(context),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child:
                Text('Education', style: CommonStyle.size20W700black(context)),
          ),
          _buildEducation(context),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: Text('Technical Skill',
                style: CommonStyle.size20W700black(context)),
          ),
          _buildTechnicalSkills(context),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: Text('Professional Experience',
                style: CommonStyle.size20W700black(context)),
          ),
          _buildProfessionalExperiences(context),
        ],
      ),
    );
  }

  Widget _buildAction(BuildContext context) {
    return Column(
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
      mainAxisAlignment: MainAxisAlignment.center,
    );
  }

  Widget _buildProfessional(BuildContext context) {
    return Column(
      children: cvModel.technicalSummaryList
          .map((summary) => _buildProfessionalItem(context, summary))
          .toList(),
    );
  }

  Widget _buildProfessionalItem(BuildContext context, String summaryItem) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Icon(
            Icons.circle,
            color: Colors.black,
            size: 8,
          ),
          SizedBox(width: 16.0),
          Text(summaryItem)
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

  // Build Education item
  Widget _buildEducationItem(BuildContext context, Education education) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Column(
        children: [
          Text('${education.schoolNm} - class of ${education.classYear}'),
          Text('Major: ${education.majorNm}')
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

  // Build Technical skill item
  Widget _buildTechnicalSkillItem(BuildContext context, Skill skill) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
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

  // Build Professional Experience list
  Widget _buildProfessionalExperiences(BuildContext context) {
    return Column(
      children: cvModel.professionalList
          .map((professional) =>
              _buildProfessionalExperienceItem(context, professional))
          .toList(),
    );
  }

  // Build Professional Experience item
  Widget _buildProfessionalExperienceItem(
      BuildContext context, Professional professional) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
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
              Text('${professional.startDate} - ${professional.endDate}')
            ],
          ),
          RichTextCommon(
            boldText: 'Role: ',
            regularText: professional.roleNm,
          ),
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: professional.responsibilities
                .map((responsibility) => Row(
                      children: [
                        Icon(
                          Icons.circle,
                          color: Colors.black,
                          size: 8,
                        ),
                        SizedBox(width: 16.0),
                        Text(
                          '$responsibility',
                          style: CommonStyle.size12W400black(context),
                        )
                      ],
                    ))
                .toList(),
          )
        ],
      ),
    );
  }
}
