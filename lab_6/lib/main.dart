import 'package:flutter/material.dart';
import 'question.dart';

void main() => runApp(const Quizzler());

class Quizzler extends StatelessWidget {
  const Quizzler({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.grey.shade900,
        body: const SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: QuizPage(),
          ),
        ),
      ),
    );
  }
}

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  // Danh sách lưu trữ các icon hiển thị kết quả (Score Keeper)
  List<Widget> scoreKeeper = [];
  
  // Điểm số đạt được
  int score = 0;

  // Danh sách các câu hỏi
  List<Question> questionBank = [
    Question(
        questionText: 'Việt Nam có đường biên giới với Campuchia.',
        questionAnswer: true),
    Question(
        questionText: 'Hà Nội là thủ đô của Việt Nam.', 
        questionAnswer: true),
    Question(
        questionText: 'Mặt trời quay quanh trái đất.', 
        questionAnswer: false),
    Question(
        questionText: 'Chuột Mickey là nhân vật của Marvel.',
        questionAnswer: false),
    Question(
        questionText: 'Con người có thể nín thở dưới nước trong 24 giờ.',
        questionAnswer: false),
  ];

  // Biến theo dõi câu hỏi hiện tại
  int questionNumber = 0;

  // Hàm kiểm tra câu trả lời
  void checkAnswer(bool userPickedAnswer) {
    bool correctAnswer = questionBank[questionNumber].questionAnswer;

    setState(() {
      // Xử lý kiểm tra kết quả và cập nhật Score Keeper, Điểm số
      if (userPickedAnswer == correctAnswer) {
        score++;
        scoreKeeper.add(const Icon(Icons.check, color: Colors.green));
      } else {
        scoreKeeper.add(const Icon(Icons.close, color: Colors.red));
      }

      // Kiểm tra xem đã hết câu hỏi chưa
      if (questionNumber < questionBank.length - 1) {
        questionNumber++;
      } else {
        // Hết câu hỏi -> Chuyển sang màn hình kết quả (ResultPage)
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResultPage(
              score: score,
              totalQuestions: questionBank.length,
              scoreKeeper: scoreKeeper,
              onRetry: () {
                // Reset lại game khi người dùng ấn "Làm lại"
                setState(() {
                  questionNumber = 0;
                  score = 0;
                  scoreKeeper.clear();
                });
                Navigator.pop(context);
              },
            ),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        // Vùng hiển thị câu hỏi
        Expanded(
          flex: 5,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Center(
              child: Text(
                questionBank[questionNumber].questionText,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 25.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        // Nút bấm "Đúng"
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                )
              ),
              child: const Text(
                'Đúng',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
              ),
              onPressed: () {
                checkAnswer(true);
              },
            ),
          ),
        ),
        // Nút bấm "Sai"
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                )
              ),
              child: const Text(
                'Sai',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
              ),
              onPressed: () {
                checkAnswer(false);
              },
            ),
          ),
        ),
        // Thanh ghi điểm (Score Keeper)
        Row(
          children: scoreKeeper,
        )
      ],
    );
  }
}

// --- Màn hình kết quả (ResultPage) ---
class ResultPage extends StatelessWidget {
  final int score;
  final int totalQuestions;
  final List<Widget> scoreKeeper;
  final VoidCallback onRetry;

  const ResultPage({
    super.key,
    required this.score,
    required this.totalQuestions,
    required this.scoreKeeper,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      appBar: AppBar(
        title: const Text(
          'Kết Quả',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.grey.shade800,
        automaticallyImplyLeading: false, // Ẩn nút back mặc định
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Hoàn thành!',
              style: TextStyle(
                color: Colors.white, 
                fontSize: 32, 
                fontWeight: FontWeight.bold
              ),
            ),
            const SizedBox(height: 30),
            Text(
              'Điểm số: $score / $totalQuestions',
              style: const TextStyle(
                color: Colors.white, 
                fontSize: 24
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Kết quả các câu:',
              style: TextStyle(color: Colors.white70, fontSize: 18),
            ),
            const SizedBox(height: 10),
            // Hiển thị lại thanh ScoreKeeper để thấy được các câu đúng/sai
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: scoreKeeper,
            ),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                )
              ),
              child: const Text(
                'Làm Lại',
                style: TextStyle(fontSize: 22, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
