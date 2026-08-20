class ApiEndpoints {

  static const register = '/api/Auth/register';
  static const login = '/api/Auth/login';
  static const refreshToken = '/api/Auth/refresh_token';
  static const logout = '/api/Auth/logout';


  static const meInfo = '/api/Me/info';
  static const myCourses = '/api/Me/courses';
  static const mySearches = '/api/Me/searches';


  static const enroll = '/api/Student/enroll';
  static const pay = '/api/Student/pay';
  static const review = '/api/Student/review';
  static const submitTest = '/api/Student/submit-test';






  static const courses = '/api/Course';
  static const mostUsedSearches = '/api/Course/search/most-used';
  static String course(int id) => '/api/Course/$id';
  static String courseImage(int id) => '/api/Course/$id/image';
  static String courseInfo(int id) => '/api/Course/$id/info';
  static String courseSection(int courseId) =>
      '/api/Course/$courseId/section';
  static String courseContent({
    required int courseId,
    required int sectionId,
  }) => '/api/Course/$courseId/section/$sectionId/content';
  static String courseQuiz({
    required int courseId,
    required int sectionId,
  }) => '/api/Course/$courseId/section/$sectionId/quiz';
  static String courseContentFile({
    required int courseId,
    required int contentId,
  }) => '/api/Course/$courseId/content/$contentId/file';
  static String courseContentAttachment({
    required int courseId,
    required int contentId,
  }) => '/api/Course/$courseId/content/$contentId/attachment';
  static const courseCategories = '/api/Course/category';
  static String courseCategory(int id) => '/api/Course/category/$id';
  static String courseTags(int id) => '/api/Course/tags/$id';




  static const teachers = '/api/Teacher';
  static String teacher(int id) => '/api/Teacher/$id';
  static String teacherImage(int id) => '/api/Teacher/$id/image';


  static String progress(int contentId) => '/api/Me/progress/$contentId';
}
