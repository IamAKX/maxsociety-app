import 'package:flutter/material.dart';
import 'package:maxsociety/util/colors.dart';
import 'package:maxsociety/util/theme.dart';
import 'package:maxsociety/widget/heading.dart';

class AboutSocietyScreen extends StatefulWidget {
  const AboutSocietyScreen({super.key});
  static const String routePath = '/aboutSocietyScreen';

  @override
  State<AboutSocietyScreen> createState() => _AboutSocietyScreenState();
}

class _AboutSocietyScreenState extends State<AboutSocietyScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Heading(title: 'About Society'),
      ),
      body: getBody(context),
      backgroundColor: backgroundDark,
    );
  }

  getBody(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(defaultPadding),
      children: [
        Container(
          padding: const EdgeInsets.all(defaultPadding),
          decoration: BoxDecoration(
            color: background,
            border: Border.all(
              color: dividerColor,
            ),
            borderRadius: BorderRadius.circular(defaultPadding / 4),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'ADDRESS',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  InkWell(
                    onTap: () {},
                    child: const Icon(
                      Icons.copy,
                      size: 20,
                      color: primaryColor,
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: defaultPadding / 2,
              ),
              Text(
                'Max  Society,\nStreet, Normad lane,Andheri East,\nMumbai, Maharastra - 100001',
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ],
          ),
        ),
        const SizedBox(
          height: defaultPadding * 1.5,
        ),
        Container(
          padding: const EdgeInsets.all(defaultPadding),
          decoration: BoxDecoration(
            color: background,
            border: Border.all(
              color: dividerColor,
            ),
            borderRadius: BorderRadius.circular(defaultPadding / 4),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'OTHER DETAILS',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  InkWell(
                    onTap: () {},
                    child: const Icon(
                      Icons.call_outlined,
                      size: 20,
                      color: Colors.green,
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: defaultPadding / 2,
              ),
              detailRow(context, 'Registration Date', '27 Aug, 1994'),
              detailRow(context, 'Rera Reg. No.', '106HF51N'),
              detailRow(context, 'Soceity Registration Number', '53628192'),
              detailRow(context, 'Ward No.', '15'),
            ],
          ),
        ),
      ],
    );
  }

  Row detailRow(BuildContext context, String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.titleSmall,
        ),
      ],
    );
  }
}
