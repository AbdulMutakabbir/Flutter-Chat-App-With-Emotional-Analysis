import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PHQ9Test extends StatefulWidget {
  final String userId;

  final VoidCallback doneTest;

  const PHQ9Test({this.userId, this.doneTest});

  @override
  State<StatefulWidget> createState() => PHQ9TestState();
}

class PHQ9TestState extends State<PHQ9Test> {

  void setTakenTest(int total)async{

    await Firestore.instance.collection("emotions").document(widget.userId).updateData({
      "test_taken" : total,
      "emotion_count": 0
    });

  }

  int currentQuestionNumber = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(115, 40, 182, 1),
        title: Text(
          'YAAS App',
          style: TextStyle(
            fontSize: 35,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(115, 40, 182, 1),
                      borderRadius: BorderRadius.circular(8)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Please answer a few questions so as to better understand you based on the last 2 weeks of experience",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              generateQuestionAndAnswer(options, currentQuestionNumber),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  NavButton("Previous", Icon(Icons.navigate_before,color: Colors.white), true, onPrevious),
                  (currentQuestionNumber == 8 ) ? NavButton("Submit", null, false, onSubmit) : NavButton("Next", Icon(Icons.navigate_next,color: Colors.white), false, onNext)
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onPrevious(){
    if(currentQuestionNumber > 0){
      setState(() {
        currentQuestionNumber--;
      });
    }
  }

  void onNext(){
    if(_radioGrpValues[currentQuestionNumber] != -1 && currentQuestionNumber < 8){
      setState(() {
        currentQuestionNumber++;
      });
    }
  }

  void onSubmit(){
    if(_radioGrpValues[currentQuestionNumber] != -1 && currentQuestionNumber == 8){
      int total = 0;
      for(int totalScore in _radioGrpValues){
        total += totalScore;
      }
      print("Total score of PHQ9: $total ");

      setTakenTest(total);
      widget.doneTest();
    }
  }

  Widget NavButton(String label,Widget icon, bool isRight, Function() onPressed){
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: Color.fromRGBO(115, 40, 182, 1),
          borderRadius: BorderRadius.circular(8)
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: <Widget>[
              isRight ? (icon == null) ? Text("") : icon : Text(""),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(label,style: TextStyle(color: Colors.white,fontSize: 18)),
              ),
              isRight ? Text("") : (icon == null) ? Text("") : icon,
            ],
          ),
        ),
      ),
    );

  }

  Widget generateQuestionAndAnswer(List<String> options, int index) {
    List<Widget> questionAndAnswer = new List<Widget>();
    questionAndAnswer.add(Text(
      questions[index],
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Color.fromRGBO(115, 40, 182, 1),
      ),
    ));
    for (var i = 0; i < options.length; i++) {
      questionAndAnswer.add(
          RadioButtonWithText(_radioGrpValues[index], i, options[i], index));
    }
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Card(
        elevation: 3,
        child: Container(
          height: 400,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: questionAndAnswer),
          ),
        ),
      ),
    );
  }

  var questions = [
    "Little interst or pleasure in doing things",
    "Feeling down, depressed or hopeless",
    "Trouble falling asleep, staying asleep, or sleeping too much",
    "Feeling tired or having little energy",
    "Poor appetite or overeating",
    "Feeling bad about yourself - or that you're a failure or have let yourself or your family down",
    "Trouble concentrating on things",
    "Moving or speaking slowly that other people could have noticed. Or the opposite being true.",
    "Thoughts that you would be better off dead or of hurting yourself in some way"
  ];
  var options = [
    "Not At all",
    "Several Days",
    "More Than Half the Days",
    "Nearly Every Day"
  ];
  var _radioGrpValues = [-1, -1, -1, -1, -1, -1, -1, -1, -1];

  Widget RadioButtonWithText(int radioGroup, int value, String label,
      int index) {
    return Container(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _radioGrpValues[index] = value;
            print("question: $index    value: $value");
          });
        },
        child: Row(
          children: <Widget>[
            Theme(
              data: Theme.of(context).copyWith(
                  disabledColor: Color.fromRGBO(115, 40, 182, 1),
                  primaryColor: Colors.red
              ),
              child: Radio(
                value: value,
                groupValue: radioGroup,
                activeColor: Color.fromRGBO(115, 40, 182, 1),
              ),
            ),
            Expanded(child: Text(label, style: TextStyle(
                color: (_radioGrpValues[index] == value) ? Color.fromRGBO(
                    115, 40, 182, 1) : Colors.grey),))
          ],
        ),
      ),
    );
  }

}

