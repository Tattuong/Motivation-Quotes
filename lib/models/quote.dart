class Quote {
  final String id;
  final String textEn;
  final String textVi;
  final String authorEn;
  final String authorVi;
  final String category;

  const Quote({
    required this.id,
    required this.textEn,
    required this.textVi,
    required this.authorEn,
    required this.authorVi,
    required this.category,
  });

  String textFor(String languageCode) => languageCode == 'vi' ? textVi : textEn;
  String authorFor(String languageCode) => languageCode == 'vi' ? authorVi : authorEn;
}

class QuoteRepository {
  QuoteRepository._();

  static const List<Quote> all = [
    Quote(
      id: 'q1',
      textEn: 'The only way to do great work is to love what you do.',
      textVi: 'Cách duy nhất để làm việc tuyệt vời là yêu thích công việc của bạn.',
      authorEn: 'Steve Jobs',
      authorVi: 'Steve Jobs',
      category: 'success',
    ),
    Quote(
      id: 'q2',
      textEn: 'Believe you can and you\'re halfway there.',
      textVi: 'Tin rằng bạn có thể và bạn đã đi được nửa chặng đường.',
      authorEn: 'Theodore Roosevelt',
      authorVi: 'Theodore Roosevelt',
      category: 'motivation',
    ),
    Quote(
      id: 'q3',
      textEn: 'It does not matter how slowly you go as long as you do not stop.',
      textVi: 'Không quan trọng bạn đi chậm thế nào, miễn là bạn không dừng lại.',
      authorEn: 'Confucius',
      authorVi: 'Khổng Tử',
      category: 'perseverance',
    ),
    Quote(
      id: 'q4',
      textEn: 'Success is not final, failure is not fatal: it is the courage to continue that counts.',
      textVi: 'Thành công không phải là đích cuối, thất bại không phải là chết chóc: lòng dũng cảm tiếp tục mới là điều quan trọng.',
      authorEn: 'Winston Churchill',
      authorVi: 'Winston Churchill',
      category: 'success',
    ),
    Quote(
      id: 'q5',
      textEn: 'The future belongs to those who believe in the beauty of their dreams.',
      textVi: 'Tương lai thuộc về những ai tin vào vẻ đẹp của ước mơ.',
      authorEn: 'Eleanor Roosevelt',
      authorVi: 'Eleanor Roosevelt',
      category: 'dreams',
    ),
    Quote(
      id: 'q6',
      textEn: 'Don\'t watch the clock; do what it does. Keep going.',
      textVi: 'Đừng nhìn đồng hồ; hãy làm như nó — tiếp tục đi.',
      authorEn: 'Sam Levenson',
      authorVi: 'Sam Levenson',
      category: 'motivation',
    ),
    Quote(
      id: 'q7',
      textEn: 'Everything you\'ve ever wanted is on the other side of fear.',
      textVi: 'Mọi thứ bạn từng mong muốn đều ở phía bên kia của nỗi sợ.',
      authorEn: 'George Addair',
      authorVi: 'George Addair',
      category: 'courage',
    ),
    Quote(
      id: 'q8',
      textEn: 'Happiness is not something ready made. It comes from your own actions.',
      textVi: 'Hạnh phúc không phải thứ có sẵn. Nó đến từ hành động của chính bạn.',
      authorEn: 'Dalai Lama',
      authorVi: 'Đức Dalai Lama',
      category: 'happiness',
    ),
    Quote(
      id: 'q9',
      textEn: 'What lies behind us and what lies before us are tiny matters compared to what lies within us.',
      textVi: 'Những gì phía sau và phía trước chúng ta đều nhỏ bé so với điều nằm bên trong.',
      authorEn: 'Ralph Waldo Emerson',
      authorVi: 'Ralph Waldo Emerson',
      category: 'wisdom',
    ),
    Quote(
      id: 'q10',
      textEn: 'Act as if what you do makes a difference. It does.',
      textVi: 'Hãy hành động như thể điều bạn làm tạo ra sự khác biệt. Vì nó có.',
      authorEn: 'William James',
      authorVi: 'William James',
      category: 'motivation',
    ),
    Quote(
      id: 'q11',
      textEn: 'You are never too old to set another goal or to dream a new dream.',
      textVi: 'Bạn không bao giờ quá già để đặt mục tiêu mới hay mơ một giấc mơ mới.',
      authorEn: 'C.S. Lewis',
      authorVi: 'C.S. Lewis',
      category: 'dreams',
    ),
    Quote(
      id: 'q12',
      textEn: 'The best time to plant a tree was 20 years ago. The second best time is now.',
      textVi: 'Thời điểm tốt nhất để trồng cây là 20 năm trước. Thời điểm tốt thứ hai là bây giờ.',
      authorEn: 'Chinese Proverb',
      authorVi: 'Tục ngữ Trung Quốc',
      category: 'wisdom',
    ),
    Quote(
      id: 'q13',
      textEn: 'Start where you are. Use what you have. Do what you can.',
      textVi: 'Bắt đầu từ nơi bạn đang đứng. Dùng những gì bạn có. Làm những gì bạn có thể.',
      authorEn: 'Arthur Ashe',
      authorVi: 'Arthur Ashe',
      category: 'motivation',
    ),
    Quote(
      id: 'q14',
      textEn: 'Difficult roads often lead to beautiful destinations.',
      textVi: 'Con đường khó khăn thường dẫn đến những điểm đến tuyệt đẹp.',
      authorEn: 'Unknown',
      authorVi: 'Không rõ',
      category: 'perseverance',
    ),
    Quote(
      id: 'q15',
      textEn: 'Your limitation—it\'s only your imagination.',
      textVi: 'Giới hạn của bạn — chỉ là trí tưởng tượng của bạn.',
      authorEn: 'Unknown',
      authorVi: 'Không rõ',
      category: 'mindset',
    ),
    Quote(
      id: 'q16',
      textEn: 'Push yourself, because no one else is going to do it for you.',
      textVi: 'Thúc đẩy bản thân, vì không ai khác sẽ làm điều đó cho bạn.',
      authorEn: 'Unknown',
      authorVi: 'Không rõ',
      category: 'motivation',
    ),
    Quote(
      id: 'q17',
      textEn: 'Great things never come from comfort zones.',
      textVi: 'Những điều vĩ đại không bao giờ đến từ vùng an toàn.',
      authorEn: 'Unknown',
      authorVi: 'Không rõ',
      category: 'courage',
    ),
    Quote(
      id: 'q18',
      textEn: 'Dream it. Wish it. Do it.',
      textVi: 'Mơ nó. Ước nó. Làm nó.',
      authorEn: 'Unknown',
      authorVi: 'Không rõ',
      category: 'dreams',
    ),
    Quote(
      id: 'q19',
      textEn: 'Success doesn\'t just find you. You have to go out and get it.',
      textVi: 'Thành công không tự tìm đến bạn. Bạn phải ra ngoài và giành lấy nó.',
      authorEn: 'Unknown',
      authorVi: 'Không rõ',
      category: 'success',
    ),
    Quote(
      id: 'q20',
      textEn: 'The harder you work for something, the greater you\'ll feel when you achieve it.',
      textVi: 'Bạn càng nỗ lực vì điều gì đó, bạn càng cảm thấy tuyệt vời khi đạt được nó.',
      authorEn: 'Unknown',
      authorVi: 'Không rõ',
      category: 'success',
    ),
    Quote(
      id: 'q21',
      textEn: 'Don\'t stop when you\'re tired. Stop when you\'re done.',
      textVi: 'Đừng dừng khi bạn mệt. Hãy dừng khi bạn hoàn thành.',
      authorEn: 'Unknown',
      authorVi: 'Không rõ',
      category: 'perseverance',
    ),
    Quote(
      id: 'q22',
      textEn: 'Wake up with determination. Go to bed with satisfaction.',
      textVi: 'Thức dậy với quyết tâm. Đi ngủ với sự hài lòng.',
      authorEn: 'Unknown',
      authorVi: 'Không rõ',
      category: 'motivation',
    ),
    Quote(
      id: 'q23',
      textEn: 'Do something today that your future self will thank you for.',
      textVi: 'Làm điều gì đó hôm nay mà bản thân tương lai sẽ cảm ơn bạn.',
      authorEn: 'Unknown',
      authorVi: 'Không rõ',
      category: 'wisdom',
    ),
    Quote(
      id: 'q24',
      textEn: 'Little things make big days.',
      textVi: 'Những điều nhỏ bé tạo nên những ngày lớn lao.',
      authorEn: 'Unknown',
      authorVi: 'Không rõ',
      category: 'happiness',
    ),
    Quote(
      id: 'q25',
      textEn: 'It\'s going to be hard, but hard does not mean impossible.',
      textVi: 'Sẽ rất khó, nhưng khó không có nghĩa là không thể.',
      authorEn: 'Unknown',
      authorVi: 'Không rõ',
      category: 'perseverance',
    ),
    Quote(
      id: 'q26',
      textEn: 'Don\'t downgrade your dream just to fit your reality. Upgrade your conviction to match your destiny.',
      textVi: 'Đừng hạ thấp ước mơ để vừa với hiện thực. Hãy nâng cao niềm tin để xứng với số phận.',
      authorEn: 'Unknown',
      authorVi: 'Không rõ',
      category: 'dreams',
    ),
    Quote(
      id: 'q27',
      textEn: 'The secret of getting ahead is getting started.',
      textVi: 'Bí mật để tiến lên là bắt đầu.',
      authorEn: 'Mark Twain',
      authorVi: 'Mark Twain',
      category: 'motivation',
    ),
    Quote(
      id: 'q28',
      textEn: 'You don\'t have to be great to start, but you have to start to be great.',
      textVi: 'Bạn không cần phải giỏi để bắt đầu, nhưng bạn phải bắt đầu để trở nên giỏi.',
      authorEn: 'Zig Ziglar',
      authorVi: 'Zig Ziglar',
      category: 'success',
    ),
    Quote(
      id: 'q29',
      textEn: 'Quality is not an act, it is a habit.',
      textVi: 'Chất lượng không phải một hành động, mà là một thói quen.',
      authorEn: 'Aristotle',
      authorVi: 'Aristotle',
      category: 'wisdom',
    ),
    Quote(
      id: 'q30',
      textEn: 'Be the change that you wish to see in the world.',
      textVi: 'Hãy là sự thay đổi mà bạn muốn thấy trên thế giới.',
      authorEn: 'Mahatma Gandhi',
      authorVi: 'Mahatma Gandhi',
      category: 'wisdom',
    ),
  ];

  static Quote? find(String id) {
    for (final q in all) {
      if (q.id == id) return q;
    }
    return null;
  }

  static List<Quote> byCategory(String category) =>
      all.where((q) => q.category == category).toList();

  static List<String> get categories =>
      all.map((q) => q.category).toSet().toList()..sort();

  static Quote dailyQuote(DateTime date) {
    final dayOfYear = date.difference(DateTime(date.year, 1, 1)).inDays;
    return all[dayOfYear % all.length];
  }
}
