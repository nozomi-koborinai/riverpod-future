import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_future/main_page_vm.dart';

class MainPage extends ConsumerStatefulWidget {
  const MainPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  ConsumerState<MainPage> createState() => _MainPageState();
}

class _MainPageState extends ConsumerState<MainPage> {
  late MainPageVM _vm;

  @override
  void initState() {
    super.initState();
    _vm = MainPageVM();
    _vm.setRef(ref);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                onChanged: ((value) => _vm.onPostalCodeChanged(value)),
              ),

              //whenを使うことで場面に応じてWidgetを切り替えてくれる
              //data：Future型でデータ取得が正常に行われた時
              //error：Future型でデータ取得に失敗した時
              //loading：Future型のデータを取得中の時（非同期処理中）
              Expanded(
                child: _vm.postalCodeWithFamily(_vm.postalcode).when(
                      data: (data) => ListView.separated(
                        separatorBuilder: (context, index) =>
                            const Divider(color: Colors.black),
                        itemCount: data.data.length,
                        itemBuilder: (context, index) => ListTile(
                            title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(data.data[0].en.prefecture),
                            Text(data.data[0].en.address1),
                            Text(data.data[0].en.address2),
                            Text(data.data[0].en.address3),
                            Text(data.data[0].en.address4),
                          ],
                        )),
                      ),
                      error: (error, stack) => Text(error.toString()),
                      loading: () => const AspectRatio(
                          aspectRatio: 1, child: CircularProgressIndicator()),
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
