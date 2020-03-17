import 'package:flutter/material.dart';
import 'package:shop_app/providers/product.dart';
import 'package:shop_app/providers/products.dart';
import 'package:provider/provider.dart';

class EditProductScreen extends StatefulWidget {
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final TextEditingController imageUrlController = TextEditingController();
  String imageUrl;
  Product product;
  String productId;
  bool isLoading = false;

  // adding the form key : this is akin to the name of forms on web development
  //it is a handle for getting access to the specific form for different purposes
  final _formKey = GlobalKey<FormState>();

  Map<String, String> productSkeleton = {
    "id": DateTime
        .now()
        .millisecondsSinceEpoch
        .toString()
  };

  void saveFormData(BuildContext context) {
    final bool isValid = _formKey.currentState.validate();
    if (isValid) {
      _formKey.currentState.save();
      if (productSkeleton["title"] != null &&
          productSkeleton["description"] != null &&
          productSkeleton["price"] != null &&
          productSkeleton["imageUrl"] != null) {
//        print("inside" + productSkeleton["id"]);
        product = Product(
          isFavorite: (productSkeleton["isFavorite"] != null)
              ? (productSkeleton["isFavorite"].toLowerCase() == "true")
              : false,
          id: productSkeleton["id"],
          title: productSkeleton["title"],
          description: productSkeleton["description"],
          imageUrl: productSkeleton["imageUrl"],
          price: double.parse(
            productSkeleton["price"],
          ),
        );
        setState(() {
          isLoading = true;
        });
        final productProvider = Provider.of<Products>(context);
        productProvider
            .addProduct(item: product, id: productSkeleton["id"])
            .then((_) {
          setState(() {
            isLoading = false;
          });
          Navigator.of(context).pop();
        }).catchError((e) {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text("Oops! Error!"),
                  content:
                  Text("It appears we have run into some error dears!"),
                  actions: <Widget>[
                    RaisedButton(
                      child: Text("Dismiss", style: TextStyle(color: Colors.white70),),
                      onPressed: () {
                        Navigator.of(context).pushReplacementNamed("/user_products_screen");
                      },
                    )
                  ],);
              });
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Product productArg;
    Map routeArgs = ModalRoute
        .of(context)
        .settings
        .arguments;
    if (routeArgs != null) {
      productArg = routeArgs["product"];
      productSkeleton["id"] = productArg.id;
      productSkeleton["isFavorite"] = productArg.isFavorite.toString();
      imageUrlController.text = productArg.imageUrl ?? "";
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Product"),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              saveFormData(context);
            },
            icon: Icon(
              Icons.save,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: (isLoading)
          ? Center(
        child: CircularProgressIndicator(
          backgroundColor: Colors.deepOrange,
        ),
      )
          : Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextFormField(
                  initialValue:
                  (productArg != null) ? productArg.title : "",
                  autocorrect: true,
                  decoration: InputDecoration(labelText: "Title"),
                  textInputAction: TextInputAction.next,
                  onSaved: (data) {
                    productSkeleton["title"] = data;
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Value cannot be empty";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  initialValue: (productArg != null)
                      ? productArg.price.toStringAsFixed(2)
                      : "",
                  autocorrect: true,
                  decoration: InputDecoration(labelText: "Price"),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  onSaved: (data) {
                    productSkeleton["price"] = data.toString();
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Value cannot be empty";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  initialValue:
                  (productArg != null) ? productArg.description : "",
                  autocorrect: true,
                  decoration: InputDecoration(labelText: "Description"),
                  maxLines: 4,
                  keyboardType: TextInputType.multiline,
                  onSaved: (data) {
                    productSkeleton["description"] = data;
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Value cannot be empty";
                    }
                    return null;
                  },
                ),
                Row(children: <Widget>[
                  Expanded(
                    child: TextFormField(
                      controller: imageUrlController,
                      keyboardType: TextInputType.multiline,
                      maxLines: 5,
                      decoration: InputDecoration(
                          labelText: "Image URL",
                          hintText: "http://www.example.com/image.png"),
                      onSaved: (data) {
                        productSkeleton["imageUrl"] = data;
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Value cannot be empty";
                        }
                        return null;
                      },
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: Container(
                        child: Image.network(imageUrlController.text),
                      ),
                    ),
                  ),
                ])
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    imageUrlController.dispose();
    super.dispose();
  }
}
