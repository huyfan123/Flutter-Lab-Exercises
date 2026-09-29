import 'story.dart';

class StoryBrain {
  final List<Story> _storyData = [
    Story(
        storyTitle:
            'Xe của bạn bị xẹp lốp trên một con đường vắng. Bạn quyết định đi nhờ xe. Một chiếc xe tải màu gỉ sét dừng lại bên cạnh bạn. Một người đàn ông với đôi mắt vô hồn mở cửa xe và hỏi: "Cần đi nhờ không?"',
        choice1: 'Đồng ý đi nhờ. Cám ơn vì sự giúp đỡ!',
        choice2: 'Khoan đã, tốt hơn là tôi nên hỏi anh ta trước xem anh ta có phải là kẻ giết người không.'),
    Story(
        storyTitle: 'Anh ta từ từ gật đầu, không hề e ngại với câu hỏi.',
        choice1: 'Ít ra anh ta cũng trung thực. Lên xe thôi.',
        choice2: 'Thôi, tôi nghĩ tôi nên đi bộ.'),
    Story(
        storyTitle:
            'Khi bạn bắt đầu lái xe, người đàn ông lạ mặt bắt đầu nói về mối quan hệ của anh ta với mẹ của anh ta. Mọi chuyện ngày càng trở nên kỳ quái. Anh ta yêu cầu bạn mở ngăn đựng găng tay. Bên trong bạn tìm thấy một con dao dính máu, 2 ngón tay bị cắt đứt và một cuốn băng cassette Elton John.',
        choice1: 'Tôi thích Elton John! Đưa tôi cuốn băng đó.',
        choice2: 'Chạy trốn thôi!'),
    Story(
        storyTitle:
            'Chà, hóa ra anh ta là một người tốt. Anh ta hát theo cuốn băng trong khi chở bạn đến trạm xăng tiếp theo.',
        choice1: 'Bắt đầu lại',
        choice2: ''),
    Story(
        storyTitle:
            'Khi bạn chạy qua lan can can hộ, bạn vô tình vấp phải ổ gà và ngã. Anh ta bắt kịp bạn...',
        choice1: 'Bắt đầu lại',
        choice2: ''),
    Story(
        storyTitle:
            'Bạn đi bộ một lúc thì kiệt sức và một chiếc xe tải khác đi qua chạy mất. Có vẻ như bạn không gặp may.',
        choice1: 'Bắt đầu lại',
        choice2: '')
  ];

  int _storyNumber = 0;

  String getStory() {
    return _storyData[_storyNumber].storyTitle;
  }

  String getChoice1() {
    return _storyData[_storyNumber].choice1;
  }

  String getChoice2() {
    return _storyData[_storyNumber].choice2;
  }

  void nextStory(int choiceNumber) {
    if (choiceNumber == 1 && _storyNumber == 0) {
      _storyNumber = 2;
    } else if (choiceNumber == 2 && _storyNumber == 0) {
      _storyNumber = 1;
    } else if (choiceNumber == 1 && _storyNumber == 1) {
      _storyNumber = 2;
    } else if (choiceNumber == 2 && _storyNumber == 1) {
      _storyNumber = 5;
    } else if (choiceNumber == 1 && _storyNumber == 2) {
      _storyNumber = 3;
    } else if (choiceNumber == 2 && _storyNumber == 2) {
      _storyNumber = 4;
    } else if (_storyNumber == 3 || _storyNumber == 4 || _storyNumber == 5) {
      restart();
    }
  }

  void restart() {
    _storyNumber = 0;
  }

  bool buttonShouldBeVisible() {
    if (_storyNumber == 0 || _storyNumber == 1 || _storyNumber == 2) {
      return true;
    } else {
      return false;
    }
  }
}
