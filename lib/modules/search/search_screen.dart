import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../layout/home/cubit/cubit.dart';
import '../../layout/home/cubit/states.dart';
import '../../shared/components/components.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({Key? key}) : super(key: key);
  var controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeStates>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        var list = HomeCubit.get(context).search;
        var cubit = HomeCubit.get(context);
        // var searchText = '';
        // cubit.getSearchPostsData(searchText);

        return Scaffold(
          body: Column(
              children: [
                SizedBox(height: 40),
                Row(
                  children: [
                    SizedBox(width: 10,),
                    Expanded(flex: 1, child: InkWell(onTap: () => Navigator.pop(context),child: Icon(Icons.arrow_back_ios))),
                    Expanded(
                      flex: 9,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: defaultFormField(
                            controller: controller,
                            type: TextInputType.text,
                            onChange: (value) {
                              cubit.getSearchPostsData(value.toString());
                              // searchText = value;
                            },

                            validate: (value) {
                              if (value!.isEmpty) {
                                return 'Search must not be empty';
                              }
                              return null;
                            },
                            label: 'Search',
                            prefix: Icons.search_rounded),
                      ),
                    ),
                  ],
                ),
                Expanded(child:   ListView.separated(
                  itemBuilder: (context, index) {
                    return buildPostItem(
                      cubit.posts[index],
                      context,
                      index,
                      isSearch: true
                    );



                  },
                  itemCount: list.length,
                  shrinkWrap: true,
                  // physics: NeverScrollableScrollPhysics(),
                  separatorBuilder: (BuildContext context, int index) =>
                      SizedBox(height: 8),),)
              ]
          ),
        );
      },
    );
  }
}
