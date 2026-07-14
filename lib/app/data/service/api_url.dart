class ApiUrl {

  ///local==================
  //static const baseUrl = "http://10.10.20.44:8004";
  ///live
  static const baseUrl = "http://3.107.47.75:8004";
  //static const networkUrl = "http://10.10.20.44:8004/";
  static const networkUrl = "http://3.107.47.75:8004/";


  ///<======================= For Auth part ====================>
  static const register = "$baseUrl/auth/register";
  static const activateAccount = "$baseUrl/auth/activate-account";
  static const login = "$baseUrl/auth/login";
  static const forgotPassword = "$baseUrl/auth/forgot-password";
  static const forgetPasswordOtpVerify = "$baseUrl/auth/forget-pass-otp-verify";
  static const resetPassword = "$baseUrl/auth/reset-password";
  static const resendOtp = "$baseUrl/auth/activation-code-resend";

  ///==================================✅✅Owner Profile✅✅=======================
  static const getOwnerProfile = "$baseUrl/user/profile";
  static const updateProfile = "$baseUrl/user/edit-profile";
  static const changePassword = "$baseUrl/auth/change-password";

  ///==================================✅✅Add Employee✅✅=======================
  static const addEmployee = "$baseUrl/user/add-employee";
  static const getEmployee = "$baseUrl/user/get-my-employee";
  static const editEmployee = "$baseUrl/user/edit-employee";
  static const employeeDelete = "$baseUrl/user/delete-employee";
  static String singleEmployee(String employeeId) =>
      "$baseUrl/user/get-single-employee?userId=$employeeId";
  static String getRoom(String houseId) =>
      "$baseUrl/room/get-my-room?houseId=$houseId";

  ///==================================✅✅Task✅✅=======================
  static const addTask = "$baseUrl/task/post-task";
  static const getCompleteTask = "$baseUrl/task/get-my-task?status=completed";


  static const getPendingTask = "$baseUrl/task/get-my-task?status=pending&recurrence=one_time";


  static const getRecurrenceTask = "$baseUrl/task/get-my-task?recurrence=recurrent";
  static const getOneTimeTask = "$baseUrl/task/get-my-task?recurrence=one_time";

  static const getSortTask = "$baseUrl/task/get-my-task?sort=startDateTime&recurrence=one_time";
  static const getEmployeePendingTask =
      "$baseUrl/task/get-employee-specific-current-task?sort=startDateTime&status=pending&recurrence=one_time";
  static const getEmployeeOngoingTask =
      "$baseUrl/task/get-employee-specific-task?status=ongoing";
  static const getEmployeeCompletedTask =
      "$baseUrl/task/get-employee-specific-task?status=completed";
  static const getOngoing = "$baseUrl/task/get-my-task?status=ongoing";
  static const taskDelete = "$baseUrl/task/delete-task";
  static const userAllTasks = "$baseUrl/task/get-my-task";
  static String taskSingle(String taskID) =>
      "$baseUrl/task/get-task?taskId=$taskID";

  static String userDayOfTask(String dayName) =>
      "$baseUrl/task/get-my-task?dayOfWeek=$dayName";

  static String roomTaskSingle(String roomId) =>
      "$baseUrl/task/get-my-task?status=pending&room=$roomId&recurrence=one_time";

  // employee
  static const employeeAllTask = "$baseUrl/task/get-employee-specific-task";
  static const employeeAllTaskSorted =
      "$baseUrl/task/get-employee-specific-task?sort=startDateTime&recurrence=one_time";
  static String employeeDateAllTask(String dayName) =>
      "$baseUrl/task/get-employee-specific-task?dayOfWeek=$dayName";
  static const updateStatus = "$baseUrl/task/update-task-or-grocery-status";
  static const taskPresets = "$baseUrl/task/presets";

  ///==================================✅✅Home✅✅=======================
  static const houseRomeCreate = "$baseUrl/room/post-room";
  static const myAllHouse = "$baseUrl/room/get-my-houses";
  static const allRoom = "$baseUrl/room/get-my-room";
  static const editSingleRoom = "$baseUrl/room/edit-single-room";
  static const deleteSingleRoom = "$baseUrl/room/delete-single-room";
  static String getMyRoom(String houseId) =>
      "$baseUrl/room/get-my-room?houseId=$houseId";
  static String getSingleRoom(String roomId) =>
      "$baseUrl/room/get-single-room?roomId=$roomId";
  static const houseCreate = "$baseUrl/room/post-house";

  ///==================================✅✅Budget✅✅=======================
  static const budgetCreate = "$baseUrl/wallet/post-budget";
  static const getMyBudget = "$baseUrl/wallet/get-my-budget?limit=100";
  static const getCategoryBudget = "$baseUrl/wallet/get-budget-category";
  static const deleteBudget = "$baseUrl/wallet/delete-budget";
  static const deleteExpense = "$baseUrl/wallet/delete-expense";
  static const expenseCreate = "$baseUrl/wallet/post-expense";

  static String getSingleBudget(String budgetId) =>
      "$baseUrl/wallet/get-budget?budgetId=$budgetId";
  static String overview(String month, String year) =>
      "$baseUrl/wallet/get-my-budget?budgetMonth=$month&budgetYear=$year";

  static const updateBudget = "$baseUrl/wallet/update-budget";

  ///==================================✅✅Manage✅✅=======================
  static const terms = "$baseUrl/manage/get-terms-conditions";
  static const privacy = "$baseUrl/manage/get-privacy-policy";
  static const getFaq = "$baseUrl/manage/get-faq";

  ///==================================✅✅Notification✅✅=======================
  static const notification = "$baseUrl/task/get-notifications";

  ///==================================✅✅Recipe✅✅=======================
  static const addRecipe = "$baseUrl/recipe/post-recipe";
  static const updateRecipe = "$baseUrl/recipe/update-recipe";
  static const myRecipe = "$baseUrl/recipe/get-my-recipe";
  static const searchRecipe = "$baseUrl/recipe/get-my-recipe?searchTerm";
  static const deleteRecipe = "$baseUrl/recipe/delete-recipe";
  static String favoriteRecipe(String recipeId) =>
      "$baseUrl/recipe/favorite-unfavorite-recipe?recipeId=$recipeId";
  static String singleRecipe(String recipeId) =>
      "$baseUrl/recipe/get-recipe?recipeId=$recipeId";

  static String tagFilter(String tagText) =>
      "$baseUrl/recipe/get-my-recipe?tags=$tagText";

  ///==================================✅✅Grocery✅✅=======================
  static const addGrocery = "$baseUrl/task/post-grocery";
  static const getGroceries = "$baseUrl/groceries/search";
  static const groceryDelete = "$baseUrl/task/delete-grocery";
  static const getMyGrocery = "$baseUrl/task/get-my-grocery";
  //static const getGroceryOngoing = "$baseUrl/task/get-my-grocery?status=ongoing";
  static const getGroceryOngoing = "$baseUrl/task/get-my-grocery?status=pending";
  static const groceryComplete ="$baseUrl/task/get-my-grocery?status=completed";
  static const employeeGroceryPending = "$baseUrl/task/get-my-grocery?status=pending";
  static const subscription = "$baseUrl/payment/google-play/verify-subscription";
}
