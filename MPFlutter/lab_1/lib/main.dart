import 'dart:math';

import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  TextEditingController yearTextEditingController = new TextEditingController();
  TextEditingController heightTextEditingController =
      new TextEditingController();
  TextEditingController weightTextEditingController =
      new TextEditingController();
  TextEditingController waistTextEditingController =
      new TextEditingController();

  double resultABSI = 0.0;
  double resultScore = 0.0;
  String risk = " ";
  int _value = 0;
  int _hei = 0;
  int _wei = 0;
  int _waist = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ABSI Calculator',
      home: Scaffold(
        backgroundColor: Colors.blue[100],
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text('ABSI Calculator'),
        ),
        body: Center(
            child: Container(
                width: 350,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 255,
                          height: 50,
                          color: Colors.blue[400],
                          child: Text(
                            'Sex',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        Container(
                            width: 95,
                            color: Colors.blue[400],
                            child: Container(
                                padding: EdgeInsets.all(1.0),
                                child: DropdownButton(
                                  value: _value,
                                  items: [
                                    DropdownMenuItem(
                                      child: Text('Male',
                                          style: TextStyle(fontSize: 18)),
                                      value: 0,
                                    ),
                                    DropdownMenuItem(
                                      child: Text('Female',
                                          style: TextStyle(fontSize: 18)),
                                      value: 1,
                                    ),
                                  ],
                                  onChanged: (value) {
                                    setState(() {
                                      _value = value;
                                    });
                                  },
                                )))
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 225,
                          height: 50,
                          color: Colors.blue[300],
                          child: Text(
                            'Age',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        Container(
                          width: 125,
                          height: 50,
                          color: Colors.blue[300],
                          child: TextField(
                            controller: yearTextEditingController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(suffixText: 'years'),
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 225,
                          height: 50,
                          color: Colors.blue[400],
                          child: Text(
                            'Height',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        Container(
                          width: 65,
                          height: 50,
                          color: Colors.blue[400],
                          child: TextField(
                            controller: heightTextEditingController,
                            keyboardType: TextInputType.number,
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        Container(
                            width: 60,
                            color: Colors.blue[400],
                            child: Container(
                                padding: EdgeInsets.all(1.0),
                                child: DropdownButton(
                                  value: _hei,
                                  items: [
                                    DropdownMenuItem(
                                      child: Text('cm',
                                          style: TextStyle(fontSize: 18)),
                                      value: 0,
                                    ),
                                    DropdownMenuItem(
                                      child: Text('m',
                                          style: TextStyle(fontSize: 18)),
                                      value: 1,
                                    ),
                                    DropdownMenuItem(
                                      child: Text('in',
                                          style: TextStyle(fontSize: 18)),
                                      value: 2,
                                    ),
                                    DropdownMenuItem(
                                      child: Text('ft',
                                          style: TextStyle(fontSize: 18)),
                                      value: 3,
                                    ),
                                  ],
                                  onChanged: (value) {
                                    setState(() {
                                      _hei = value;
                                    });
                                  },
                                )))
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 225,
                          height: 50,
                          color: Colors.blue[300],
                          child: Text(
                            'Weight',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        Container(
                          width: 70,
                          height: 50,
                          color: Colors.blue[300],
                          child: TextField(
                            controller: weightTextEditingController,
                            keyboardType: TextInputType.number,
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        Container(
                            width: 55,
                            color: Colors.blue[300],
                            child: Container(
                                padding: EdgeInsets.all(1.0),
                                child: DropdownButton(
                                  value: _wei,
                                  items: [
                                    DropdownMenuItem(
                                      child: Text('kg',
                                          style: TextStyle(fontSize: 18)),
                                      value: 0,
                                    ),
                                    DropdownMenuItem(
                                      child: Text('g',
                                          style: TextStyle(fontSize: 18)),
                                      value: 1,
                                    ),
                                    DropdownMenuItem(
                                      child: Text('lb',
                                          style: TextStyle(fontSize: 18)),
                                      value: 2,
                                    ),
                                  ],
                                  onChanged: (value) {
                                    setState(() {
                                      _wei = value;
                                    });
                                  },
                                )))
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 225,
                          height: 50,
                          color: Colors.blue[400],
                          child: Text(
                            'Waist Circumference',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        Container(
                          width: 65,
                          height: 50,
                          color: Colors.blue[400],
                          child: TextField(
                            controller: waistTextEditingController,
                            keyboardType: TextInputType.number,
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        Container(
                            width: 60,
                            color: Colors.blue[400],
                            child: Container(
                                padding: EdgeInsets.all(1.0),
                                child: DropdownButton(
                                  value: _waist,
                                  items: [
                                    DropdownMenuItem(
                                      child: Text('cm',
                                          style: TextStyle(fontSize: 18)),
                                      value: 0,
                                    ),
                                    DropdownMenuItem(
                                      child: Text('m',
                                          style: TextStyle(fontSize: 18)),
                                      value: 1,
                                    ),
                                    DropdownMenuItem(
                                      child: Text('in',
                                          style: TextStyle(fontSize: 18)),
                                      value: 2,
                                    ),
                                  ],
                                  onChanged: (value) {
                                    setState(() {
                                      _waist = value;
                                    });
                                  },
                                )))
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          width: 120,
                          height: 40,
                          // ignore: deprecated_member_use
                          child: RaisedButton(
                            child: Text('Calculate',
                                style: TextStyle(fontSize: 18)),
                            onPressed: calculateMe,
                          ),
                        ),
                        Container(
                          width: 120,
                          height: 40,
                          // ignore: deprecated_member_use
                          child: RaisedButton(
                            child:
                                Text('Clear', style: TextStyle(fontSize: 18)),
                            onPressed: clearMe,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 350,
                          height: 50,
                          color: Colors.blue[700],
                          child: Text(
                            'Result',
                            style: TextStyle(fontSize: 22),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 225,
                          height: 50,
                          color: Colors.blue[600],
                          child: Text(
                            'ABSI',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        Container(
                          width: 125,
                          height: 50,
                          color: Colors.blue[600],
                          child: Text(
                            " " + resultABSI.toStringAsFixed(5),
                            style: TextStyle(fontSize: 20),
                          ),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 225,
                          height: 50,
                          color: Colors.blue[600],
                          child: Text(
                            'ABSI Z-Score',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        Container(
                          width: 125,
                          height: 50,
                          color: Colors.blue[600],
                          child: Text(
                            " " + resultScore.toStringAsFixed(3),
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(children: [
                      Container(
                          width: 300,
                          height: 50,
                          child: RichText(
                              text: TextSpan(
                                  text:
                                      "According to your ABSI z score, your premature mortality risk is ",
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.black),
                                  children: [
                                TextSpan(
                                    text: "" + risk,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      decoration: TextDecoration.underline,
                                    )),
                                TextSpan(text: "."),
                              ]))),
                    ])
                  ],
                ))),
      ),
    );
  }

  void clearMe() {
    yearTextEditingController.clear();
    heightTextEditingController.clear();
    weightTextEditingController.clear();
    waistTextEditingController.clear();
    setState(() {
      resultABSI = 0.0;
      resultScore = 0.0;
      risk = " ";
    });
  }

  void calculateMe() {
    setState(() {
      var normals = [
        [
          [2, 0.07878, 0.00351, 16.12235, 1.43027],
          [2, 0.07996, 0.00332, 15.79459, 1.67808]
        ],
        [
          [3, 0.07905, 0.00351, 16.43722, 1.51885],
          [3, 0.08006, 0.00336, 16.14145, 1.82622]
        ],
        [
          [4, 0.07928, 0.00351, 16.77204, 1.81602],
          [4, 0.08014, 0.00339, 16.50933, 2.19967]
        ],
        [
          [5, 0.07946, 0.00351, 17.14201, 2.22462],
          [5, 0.08017, 0.00343, 16.91739, 2.53754]
        ],
        [
          [6, 0.07956, 0.00351, 17.55407, 2.62504],
          [6, 0.08013, 0.00346, 17.37538, 2.85349]
        ],
        [
          [7, 0.07957, 0.00351, 18.01051, 3.03285],
          [7, 0.08003, 0.00350, 17.88415, 3.15274]
        ],
        [
          [8, 0.07949, 0.00351, 18.50837, 3.44620],
          [8, 0.07986, 0.00353, 18.43824, 3.43707]
        ],
        [
          [9, 0.07932, 0.00351, 19.04125, 3.83161],
          [9, 0.07962, 0.00356, 19.02815, 3.70701]
        ],
        [
          [10, 0.07906, 0.00351, 19.60187, 4.17532],
          [10, 0.07932, 0.00360, 19.64262, 3.96318]
        ],
        [
          [11, 0.07873, 0.00352, 20.18254, 4.47574],
          [11, 0.07899, 0.00363, 20.26971, 4.20596]
        ],
        [
          [12, 0.07835, 0.00352, 20.77521, 4.73287],
          [12, 0.07865, 0.00366, 20.89793, 4.43569]
        ],
        [
          [13, 0.07794, 0.00352, 21.37166, 4.94686],
          [13, 0.07832, 0.00369, 21.51684, 4.65277]
        ],
        [
          [14, 0.07755, 0.00352, 21.96342, 5.11732],
          [14, 0.07802, 0.00372, 22.11763, 4.85764]
        ],
        [
          [15, 0.07722, 0.00352, 22.54240, 5.24857],
          [15, 0.07776, 0.00376, 22.69424, 5.05080]
        ],
        [
          [16, 0.07698, 0.00352, 23.10105, 5.34658],
          [16, 0.07755, 0.00379, 23.24211, 5.23267]
        ],
        [
          [17, 0.07686, 0.00352, 23.63293, 5.41529],
          [17, 0.07739, 0.00382, 23.75814, 5.40361]
        ],
        [
          [18, 0.07685, 0.00352, 24.13361, 5.46179],
          [18, 0.07728, 0.00385, 24.24024, 5.56395]
        ],
        [
          [19, 0.07695, 0.00352, 24.60016, 5.49187],
          [19, 0.07721, 0.00388, 24.68668, 5.71404]
        ],
        [
          [20, 0.07713, 0.00352, 25.03057, 5.50613],
          [20, 0.07718, 0.00391, 25.09702, 5.85432]
        ],
        [
          [21, 0.07737, 0.00352, 25.42382, 5.50280],
          [21, 0.07716, 0.00394, 25.47188, 5.98525]
        ],
        [
          [22, 0.07765, 0.00352, 25.77961, 5.48309],
          [22, 0.07717, 0.00397, 25.81258, 6.10726]
        ],
        [
          [23, 0.07793, 0.00352, 26.09817, 5.45621],
          [23, 0.07718, 0.00400, 26.12074, 6.22070]
        ],
        [
          [24, 0.07822, 0.00352, 26.38076, 5.43530],
          [24, 0.07720, 0.00403, 26.39806, 6.32595]
        ],
        [
          [25, 0.07849, 0.00352, 26.62914, 5.42460],
          [25, 0.07723, 0.00406, 26.64682, 6.42338]
        ],
        [
          [26, 0.07873, 0.00352, 26.84545, 5.42414],
          [26, 0.07726, 0.00409, 26.86971, 6.51337]
        ],
        [
          [27, 0.07895, 0.00352, 27.03279, 5.42510],
          [27, 0.07729, 0.00411, 27.06897, 6.59628]
        ],
        [
          [28, 0.07913, 0.00352, 27.19456, 5.42239],
          [28, 0.07733, 0.00414, 27.24685, 6.67241]
        ],
        [
          [29, 0.07928, 0.00352, 27.33454, 5.41529],
          [29, 0.07738, 0.00417, 27.40574, 6.74202]
        ],
        [
          [30, 0.07941, 0.00352, 27.45668, 5.40729],
          [30, 0.07743, 0.00420, 27.54828, 6.80537]
        ],
        [
          [31, 0.07953, 0.00352, 27.56413, 5.39705],
          [31, 0.07750, 0.00423, 27.67652, 6.86268]
        ],
        [
          [32, 0.07964, 0.00352, 27.65943, 5.38230],
          [32, 0.07757, 0.00426, 27.79217, 6.91413]
        ],
        [
          [33, 0.07977, 0.00352, 27.74445, 5.36307],
          [33, 0.07766, 0.00428, 27.89718, 6.95994]
        ],
        [
          [34, 0.07989, 0.00352, 27.82123, 5.33961],
          [34, 0.07775, 0.00431, 27.99372, 7.00031]
        ],
        [
          [35, 0.08003, 0.00352, 27.89185, 5.31236],
          [35, 0.07785, 0.00434, 28.08368, 7.03544]
        ],
        [
          [36, 0.08017, 0.00352, 27.95735, 5.27672],
          [36, 0.07794, 0.00436, 28.16788, 7.06541]
        ],
        [
          [37, 0.08032, 0.00353, 28.01875, 5.23196],
          [37, 0.07804, 0.00439, 28.24699, 7.09033]
        ],
        [
          [38, 0.08048, 0.00353, 28.07676, 5.17880],
          [38, 0.07812, 0.00442, 28.32188, 7.11031]
        ],
        [
          [39, 0.08064, 0.00353, 28.13190, 5.12399],
          [39, 0.07821, 0.00444, 28.39312, 7.12547]
        ],
        [
          [40, 0.08080, 0.00353, 28.18436, 5.07667],
          [40, 0.07830, 0.00447, 28.46150, 7.13596]
        ],
        [
          [41, 0.08095, 0.00353, 28.23385, 5.04242],
          [41, 0.07839, 0.00450, 28.52749, 7.14190]
        ],
        [
          [42, 0.08110, 0.00353, 28.28047, 5.02916],
          [42, 0.07848, 0.00452, 28.59128, 7.14340]
        ],
        [
          [43, 0.08125, 0.00353, 28.32424, 5.03077],
          [43, 0.07858, 0.00455, 28.65266, 7.14054]
        ],
        [
          [44, 0.08141, 0.00353, 28.36546, 5.04132],
          [44, 0.07868, 0.00458, 28.71110, 7.13338]
        ],
        [
          [45, 0.08159, 0.00353, 28.40451, 5.05682],
          [45, 0.07881, 0.00460, 28.76589, 7.12203]
        ],
        [
          [46, 0.08177, 0.00353, 28.44204, 5.07091],
          [46, 0.07894, 0.00463, 28.81665, 7.10660]
        ],
        [
          [47, 0.08196, 0.00353, 28.47876, 5.07676],
          [47, 0.07909, 0.00465, 28.86357, 7.08723]
        ],
        [
          [48, 0.08215, 0.00353, 28.51557, 5.07435],
          [48, 0.07924, 0.00468, 28.90737, 7.06409]
        ],
        [
          [49, 0.08235, 0.00353, 28.55335, 5.07091],
          [49, 0.07939, 0.00470, 28.94881, 7.03738]
        ],
        [
          [50, 0.08255, 0.00353, 28.59254, 5.07618],
          [50, 0.07954, 0.00473, 28.98868, 7.00732]
        ],
        [
          [51, 0.08274, 0.00353, 28.63302, 5.10186],
          [51, 0.07969, 0.00475, 29.02719, 6.97408]
        ],
        [
          [52, 0.08293, 0.00353, 28.67322, 5.14183],
          [52, 0.07983, 0.00478, 29.06458, 6.93784]
        ],
        [
          [53, 0.08311, 0.00353, 28.71150, 5.18354],
          [53, 0.07996, 0.00480, 29.10048, 6.89868]
        ],
        [
          [54, 0.08329, 0.00353, 28.74662, 5.21811],
          [54, 0.08009, 0.00483, 29.13450, 6.85670]
        ],
        [
          [55, 0.08347, 0.00353, 28.77811, 5.24200],
          [55, 0.08023, 0.00485, 29.16598, 6.81199]
        ],
        [
          [56, 0.08365, 0.00353, 28.80595, 5.25427],
          [56, 0.08038, 0.00487, 29.19338, 6.76461]
        ],
        [
          [57, 0.08382, 0.00353, 28.82988, 5.25367],
          [57, 0.08055, 0.00490, 29.21513, 6.71463]
        ],
        [
          [58, 0.08399, 0.00353, 28.84929, 5.24236],
          [58, 0.08072, 0.00492, 29.23008, 6.66220]
        ],
        [
          [59, 0.08416, 0.00353, 28.86367, 5.22743],
          [59, 0.08089, 0.00495, 29.23666, 6.60744]
        ],
        [
          [60, 0.08433, 0.00353, 28.87220, 5.21632],
          [60, 0.08107, 0.00497, 29.23350, 6.55054]
        ],
        [
          [61, 0.08451, 0.00353, 28.87307, 5.20544],
          [61, 0.08125, 0.00499, 29.22012, 6.49172]
        ],
        [
          [62, 0.08469, 0.00353, 28.86444, 5.19153],
          [62, 0.08144, 0.00502, 29.19681, 6.43126]
        ],
        [
          [63, 0.08487, 0.00354, 28.84494, 5.17373],
          [63, 0.08162, 0.00504, 29.16427, 6.36940]
        ],
        [
          [64, 0.08505, 0.00354, 28.81294, 5.15230],
          [64, 0.08180, 0.00506, 29.12233, 6.30617]
        ],
        [
          [65, 0.08521, 0.00354, 28.76718, 5.12804],
          [65, 0.08199, 0.00509, 29.07020, 6.24155]
        ],
        [
          [66, 0.08537, 0.00354, 28.70723, 5.09527],
          [66, 0.08219, 0.00511, 29.00727, 6.17551]
        ],
        [
          [67, 0.08551, 0.00354, 28.63387, 5.04928],
          [67, 0.08239, 0.00513, 28.93302, 6.10804]
        ],
        [
          [68, 0.08565, 0.00354, 28.54831, 4.99124],
          [68, 0.08260, 0.00516, 28.84713, 6.03916]
        ],
        [
          [69, 0.08578, 0.00354, 28.45194, 4.92386],
          [69, 0.08281, 0.00518, 28.74993, 5.96891]
        ],
        [
          [70, 0.08591, 0.00354, 28.34597, 4.84868],
          [70, 0.08302, 0.00520, 28.64198, 5.89736]
        ],
        [
          [71, 0.08604, 0.00354, 28.23146, 4.76637],
          [71, 0.08323, 0.00522, 28.52427, 5.82454]
        ],
        [
          [72, 0.08618, 0.00354, 28.10877, 4.67136],
          [72, 0.08343, 0.00525, 28.39737, 5.75038]
        ],
        [
          [73, 0.08631, 0.00354, 27.97754, 4.55739],
          [73, 0.08361, 0.00527, 28.26114, 5.67476]
        ],
        [
          [74, 0.08644, 0.00354, 27.83704, 4.42170],
          [74, 0.08378, 0.00529, 28.11531, 5.59758]
        ],
        [
          [75, 0.08656, 0.00354, 27.68724, 4.26942],
          [75, 0.08394, 0.00531, 27.96014, 5.51880]
        ],
        [
          [76, 0.08668, 0.00354, 27.52856, 4.11105],
          [76, 0.08409, 0.00533, 27.79603, 5.43844]
        ],
        [
          [77, 0.08679, 0.00354, 27.36219, 3.96510],
          [77, 0.08423, 0.00536, 27.62367, 5.35654]
        ],
        [
          [78, 0.08689, 0.00354, 27.18897, 3.85296],
          [78, 0.08436, 0.00538, 27.44407, 5.27315]
        ],
        [
          [79, 0.08700, 0.00354, 27.00993, 3.76891],
          [79, 0.08447, 0.00540, 27.25867, 5.18830]
        ],
        [
          [80, 0.08710, 0.00354, 26.82624, 3.69774],
          [80, 0.08458, 0.00542, 27.06876, 5.10198]
        ],
        [
          [81, 0.08720, 0.00354, 26.63900, 3.61963],
          [81, 0.08468, 0.00544, 26.87566, 5.01417]
        ],
        [
          [82, 0.08730, 0.00354, 26.44973, 3.52507],
          [82, 0.08478, 0.00547, 26.68045, 4.92484]
        ],
        [
          [83, 0.08739, 0.00354, 26.25940, 3.41808],
          [83, 0.08488, 0.00549, 26.48407, 4.83390]
        ],
        [
          [84, 0.08749, 0.00354, 26.06889, 3.31254],
          [84, 0.08497, 0.00551, 26.28733, 4.74123]
        ],
        [
          [85, 0.08811, 0.00356, 25.44250, 4.08724],
          [85, 0.08533, 0.00528, 25.97517, 4.75191]
        ]
      ];

      double bmi;
      int age = (int.parse(yearTextEditingController.text)) - 2;
      double height = (double.parse(heightTextEditingController.text));
      double weight = (double.parse(weightTextEditingController.text));
      double waist = (double.parse(waistTextEditingController.text));

      switch (_hei) {
        case 0:
          height = (double.parse(heightTextEditingController.text)) / 100;
          break;
        case 1:
          height = (double.parse(heightTextEditingController.text));
          break;
        case 2:
          height = (double.parse(heightTextEditingController.text)) * 0.0254;
          break;
        case 3:
          height = (double.parse(heightTextEditingController.text)) * 0.3048;
          break;

        default:
      }

      switch (_wei) {
        case 0:
          weight = (double.parse(weightTextEditingController.text));
          break;
        case 1:
          weight = (double.parse(weightTextEditingController.text)) / 1000;
          break;
        case 2:
          weight = (double.parse(weightTextEditingController.text)) * 0.453592;
          break;

        default:
      }

      switch (_waist) {
        case 0:
          waist = (double.parse(waistTextEditingController.text)) / 100;
          break;
        case 1:
          waist = (double.parse(waistTextEditingController.text));
          break;
        case 2:
          waist = (double.parse(waistTextEditingController.text)) * 0.0254;
          break;

        default:
      }

      bmi = weight / (pow(height, 2));
      resultABSI = waist / ((pow(bmi, 2 / 3)) * (pow(height, 1 / 2)));

      double meanABSI = normals[age][_value][1];
      double sdABSI = normals[age][_value][2];
      resultScore = (resultABSI - meanABSI) / sdABSI;

      if (resultScore < -0.868) {
        risk = 'very low';
      } else if ((resultScore >= -0.868) && (resultScore <= -0.272)) {
        risk = 'low';
      } else if ((resultScore >= -0.271) && (resultScore <= 0.229)) {
        risk = 'average';
      } else if ((resultScore >= 0.230) && (resultScore <= 0.798)) {
        risk = 'high';
      } else if (resultScore > 0.798) {
        risk = 'very high';
      }

      print(resultABSI);
      print(resultScore);
    });
  }
}
