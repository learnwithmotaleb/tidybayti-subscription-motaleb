class AppStrings {
  AppStrings._();
  static RegExp passRegexp = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.{8,}$)');
  static RegExp emailRegexp = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  static const String fieldCantBeEmpty = "Field can't be empty";
  static const String passDoesNotMatch = "Password does not match";
  static const String passwordMustHaveEightWith =
      "Password must have 8 characters With(A-z,a-z,0-9)";
  static const String enterValidEmail = "Enter a valid email";
  static const String passMustContainBoth =
      "Password must be 8 characters long & must include one capital letter";
  static const String enterAValidName = "Enter a valid name";
  static const String enterValidEamil = "Please Enter Your Email Address";
  static const String passwordLengthAndContain =
      "Password must be at least 8 characters long and at least one uppercase letter, one lowercase letter, one number";

  ///=========================Start Page===================
  static const String welcome = "Welcome";
  static const String faq = "FAQ";
  static const String id = "Id:";
  static const String bhd120 = "BHD 3.99 /month/year";
  static const String sixMonth = "6 Months package";
  static const String selectYourLanguage = "Select Your Language";
  static const String profile = "Profile";
  static const String name = "Name";
  static const String note = "Note";
  static const String cprNumber = "CPR Number";
  static const String expireDate = "Expire Date";
  static const String temporaryPassword = "Temporary Password";
  static const String bhdSix = "BHD  4.99/ monthly ";
  static const String autoRenewal = "Auto-renewal";
  static const String reNewPlan = "Re-new plan";
  static const String joiningDate = "Joining date:";
  static const String buyNewPackages = "Buy new package";
  static const String alreadyHaveAnYAccount = "Already have any account?";
  static const String emailForVerification = "email for verification.";
  static const String enterSIxDegit = "Enter 6 digit verification code";
  static const String verifyCode = "Verify Code";
  static const String updatePassword = "Update password";
  static const String upDate = "Update";
  static const String owner = "Owner";
  static const String gettingStarted = "Getting Started";
  static const String employee = "Employee";
  static const String signIn = "Sign In";
  static const String signUp = "Sign Up";
  static const String bySigningUp = "By Signing up, you agree to ";
  static const String termsOfUse = "Terms of use";
  static const String and = "and";
  static const String remember = "Remember";
  static const String privacyPolicy = "Privacy Policy";
  static const String createAnAccountAndAccess =
      "Create an account and access our awesome services";

  ///============================Authentication in Home Owner===================
  static const String email = "Email";
  static const String enterPassword = "Enter Password";
  static const String forgetPassword = "Forgot Password?";
  static const String dontHaveAnyAccount = "Don’t have any account?";
  static const String firstName = "First name";
  static const String lastName = "Last name";
  static const String language = "Language";
  static const String contactNumber = "Contact number";
  static const String password = "Password";
  static const String confirmPassword = "Confirm Password";
  static const String savePassword = "Save Password";
  static const String createAccount = "Create Account";
  static const String account = "Account";
  static const String sendYourVerificationOnYour =
      "Send your verification on your Contact number";
  static const String sendVerificationCode = "Send Verification Code";
  static const String resendConfirmationCode = "Resend Confirmation Code";
  static const String confirm = "Confirm";
  static const String confirmTask = "Confirm task";
  static const String completeTask = "Complete task";
  static const String cost = "Cost";
  static const String left = "Left";
  static const String youHaveSevenDays = "You have  7 days free service.";
  static const String ourSubscriptionPackages = "Our Subscription packages";

  ///=====================================Premium Pacage===============
  static const String congratulationsYOuAreGiven =
      "Congratulations, You are given 7 days free trail. During this trail period, you are getting this facilities !";
  static const String inviteUnlimited = 'Invite unlimited home members ';
  static const String assignTasksTo = 'Assign tasks to multiple people';
  static const String masterYourCleaningSchedule =
      'Master your cleaning schedule';
  static const String manageMultiplePlaces = 'Manage multiple places';
  static const String outSubscriptionPackages = 'Our Subscription packages';
  static const String premium = 'Premium';
  static const String assignTask = "Assign Task";
  static const String assignedTo = 'Assigned To';
  static const String premiumPro = 'Premium-Pro';
  static const String twelveMonthPackage = '12 Months package';
  static const String oneMonthsPackage = '1 Months package';
  static const String bhd3 = 'BHD 3.99/Month';
  static const String bhd4 = 'BHD 4.99/Month';
  static const String usePreset = 'Use Preset';
  static const String continues = 'Continue';
  static const String pleaseSelectHouse =
      'Please select or create a house to continue.';
  static const String congratulations =
      'Congratulations, You are given 7 days free trail. During this trail period, you are gettingthis facilities !';

  ///===============================Home Section=======================
  static const String chooseYourHouseType = 'Choose your house type';
  static const String custom = 'Custom';
  static const String mansion = 'Mansion';
  static const String bungalow = 'Bungalow';
  static const String inHome = 'In. Home';
  static const String villa = 'Villa';
  static const String house = 'House';
  static const String beachHouse = 'Beach House';
  static const String apartment = 'Apartment';
  static const String houseInformation = 'House Information';
  static const String houseName = 'House name';
  static const String addNewRoom = 'Add new room';
  static const String save = 'Save';
  static const String totalRooms = 'Total rooms';
  static const String seeAll = 'See all';
  //static const String employees = 'Employees';
  static const String employees = 'Manage Employees';
  static const String assignWork = 'Assign work';
  static const String addEmployee = 'Add employee';
  static const String employeeDetails = 'Employee details';
  static const String taskDetails = 'Task details';
  static const String task = 'Task';
  static const String assignToColon = 'Assign to:';
  static const String roomName = 'Room Name';
  static const String recurrenceColon = 'Recurrence: ';
  static const String date = 'Date:';
  static const String time = 'Time: ';
  static const String taskDetailsColon = 'Task details: ';
  static const String additionalMessageColon = 'Additionsal message:  ';
  static const String editEmployeeDetails = 'Edit employee details';
  static const String employeeName = 'Employee name';
  static const String designation = 'Designation';
  static const String jobType = 'Job type';
  static const String cPR = 'CPR';
  static const String passport = 'Passport';
  static const String passportNumber = 'Passport Number';
  static const String employeeAddedSu = 'Employee Added Successfully';
  static const String emplyeesAccountDetails =
      'Employees accounts details is sending to employee email :';
  static const String drivingLicense = 'Driving license';
  static const String address = 'Address';
  static const String confirmDelete = 'Confirm Delete';
  static const String cancel = 'Cancel';
  static const String delete = 'Delete';
  static const String dutyTime = 'Duty Time:';
  static const String workingDay = 'Working Day:';
  static const String offDay = 'Off day';
  static const String offDayColon = 'Off day:';
  static const String submit = 'Submit';
  static const String areYouSureYouWant =
      'Are you sure you want to delete this employee?';
  static const String selectWorkingDays = 'Select working days';
  static const String selectOffDays = 'Select off days';
  static const String upgradeProfile = 'Upgrade profile';
  static const String employeeAddedSuccessfully = 'Employee added successfully';
  static const String sendEmail = 'Send email';
  static const String notification = 'Notification';
  static const String mailSendSuccessfully = 'Mail sent successfully ';
  static const String assignWorkSchedule = 'Assign work schedule';
  static const String addNewEmployee = 'Add new employee';
  static const String scheduleOverview = 'Schedule overview';
  static const String backToHome = 'Back to home';
  static const String addNewTask = 'Add new task';
  static const String addBreakTime = 'Add break time';
  static const String addNewRecipe = 'Add New Recipe';
  static const String selectTags = 'Select Tags';
  static const String finish = 'Finish';
  static const String selectRoom = 'Select room';
  static const String taskTitle = 'Task title';
  static const String title = 'Title';
  static const String usePresets = 'Use presets';
  static const String startTime = 'Start time';
  static const String endDate = 'End Date';
  static const String startDate = 'Start Date';
  static const String taskDate = 'Task Date';
  static const String endTime = 'End time';
  static const String details = 'Details';
  static const String addTask = 'Add task';
  static const String recipeDetails = 'Recipe Details';
  static const String addBreak = 'Add break';
  static const String close = 'Close';
  static const String assignTaskSuccessfully = 'Assign task successfully';
  static const String noDetailsProvided = "No details provided";

  ///============================Schedule Overview=======================
  static const String workSchedule = 'Work Schedule';
  static const String taskSchedule = 'Task Schedule';
  static const String taskScheduleDetails = 'Task schedule details';
  static const String allTasks = 'All tasks';
  static const String completedTasks = 'Completed tasks';
  static const String ongoingTask = 'Ongoing task';
  static const String pendingTask = 'Pending tasks';
  static const String pending = 'Pending';
  static const String ongoing = 'Ongoing';
  static const String complete = 'Completed';
  static const String groceryList = 'Grocery list';
  static const String createTask = 'Create Task';
  static const String assignTo = 'Assign to';
  static const String recurrence = 'Recurrence';
  static const String ontime = 'Ontime';
  static const String weekly = 'Weekly';
  static const String monthly = 'Monthly';
  static const String selectDate = 'Select date';
  static const String selectTime = 'Select Time';
  static const String workDurationInMinutes = "Work Duration in minutes";
  static const String additionalMessage = 'Additional message';
  static const String downloadPdf = 'Download PDF';
  static const String additionalTask = 'Additional Task';
  static const String doYouWantToDownload =
      'Do you want to download Task details';
  static const String downloadNow = 'Download now';
  static const String grocery = 'Grocery';
  static const String addGrocery = 'Add Grocery';
  static const String pendingTasks = 'Pending tasks';
  static const String completedTask = 'Completed tasks';
  static const String addItem = 'Add item';
  static const String employeeList = 'Employee list';
  static const String selectEmployee = 'Select employee';
  static const String selected = 'Selected';
  static const String addHouse = 'Add House';
  static const String addRoom = 'Add Room';

  ///==============================wallet=============================
  static const String wallet = 'Wallet';
  static const String budget = 'Budget';
  static const String overview = 'Overview';
  static const String ok = 'OK';
  static const String createBudgets = 'Create budgets';
  static const String keepYourBudgetsOnTrack =
      'Keep your budgets on track and under control with budgets ';
  static const String selectCategory = 'Select category';
  static const String enterAmount = 'Enter amount';
  static const String budgetDetails = 'Budget details';
  static const String expenseOverview = 'Expense overview';
  static const String addExpanse = 'Add expense';
  static const String editBudget = 'Edit budget';
  static const String selectYear = 'Select year';
  static const String selectMonth = 'Select month';

  ///=============================recipe Section===================
  static const String addRecipe = 'Add recipe';
  static const String myRecipe = 'My recipe';
  static const String searchRecipe = 'Search recipe';
  static const String favoriteRecipes = 'Favorite recipes';
  static const String tags = 'Tags';
  static const String tag = 'Tags:';
  static const String ingredients = 'Ingredients:';
  static const String newBlackRecipe = 'New blank recipe';
  static const String importFromWebsite = 'Import from website';
  static const String uploadFile = 'Upload file';
  static const String recipeName = 'Recipe name';
  static const String addPhoto = 'Add photo';
  static const String urlHere = 'URL here';
  static const String cookingTime = 'Cooking time (Min)';
  static const String cookingTimes = 'Cooking time:';
  static const String description = 'Description';
  static const String addIngredients = 'Add ingredients';
  static const String describeSteps = 'Describe steps';
  static const String myRecipes = 'My recipe';
  static const String search = 'Search';
  static const String editRecipe = 'Edit recipe';

  ///==================================Menu Section======================
  static const String menu = 'Menu';
  static const String personalInformation = 'Personal Information';
  static const String upgradePackages = 'Upgrade Packages';
  static const String byeNow = 'Bye now';
  static const String myPlan = 'My plan';
  static const String settings = 'Settings';
  static const String logOut = 'Log out';
  static const String contactNo = 'Contact no:';
  static const String editProfile = 'Edit Profile';
  static const String saveAndChange = 'Save & Change';
  static const String changePassword = 'Change Password';
  static const String termsOfService = 'Terms Of Use';
  static const String aboutUs = 'About US';
  static const String helpWhere = 'Help';
  static const String presentPassword = 'Present Password';
  static const String currentPassword = 'Current Password';
  static const String newPassword = 'New Password';
  //
  static const String recipe = 'Recipe';
  static const String selectYearAndMonth = 'Select Year and Month';
  static const String specificDays = 'Specific Days';
  static const String removeYourCompleteTask = "Remove Your Complete Task";
  static const String noData = "No Data Found";
  static const String areYouSure = "Are you sure you want to delete this task?";
  static const String noTasks = "No Tasks Found";
  static const String somethingWentWrong = "Something went wrong";
  static const String noInternet = "No Internet Connection";
  static const String removeYourOngoingTask = "Remove Your Ongoing Task";
  static const String removeYourPendingTask = "Remove Your Pending Task";
  static const String selectIcon = 'Select an Icon';
  static const String icon = 'Icon';
  static const String editRoom = 'Edit Room';
  static const String noHouses = "No Houses Found";
  static const String noEmployeesFound = "No employees found";
  static const String noWorkingDaysAvailable = "No working days available";
  static const String breakTimeColon = "Break Time:";
  static const String oneTime = "One Time";
  static const String noTask = "No Task";
  static const String noTaskName = "No Task Name";
  static const String removeTask = "Remove Task";
  static const String changeIcon = 'Change Icon';
  static const String error = 'Error';
  static const String pleaseEnterRoomName = 'Please enter room name';
  static const String update = 'Update';
  static const String partTime = 'Part Time';
  static const String fullTime = "Full Time";
  static const String uploadFilePdf = 'Upload file/pdf file';
  static const String noDescriptionAvailable = "No description available.";
  static const String noFavoriteRecipes = "No Favorite Recipes Found";
  static const String untitledRecipe = "Untitled Recipe";
  static const String errorLoadingRecipes = "Error loading recipes";
  static const String noRecipeFound = "No Recipe Found";
  static const String removeMyRecipe = "Remove My Recipe";
  static const String enterGroceryItem = "Enter grocery item";
  static const String add = "Add";
  static const String removeBudget = 'Remove Budget';
  static const String noExpenseFound = "No Expense Found";
  static const String removeExpense = 'Remove Expense';
  static const String workSchedulePdf = 'Work Schedule PDF';
  static const String room = 'Room';
  static const String status = 'Status';
  static const String noNotificationsFound = "No Notifications Found";
  static const String yearsAgo = "year(s) ago";
  static const String monthsAgo = "month(s) ago";
  static const String daysAgo = "day(s) ago";
  static const String hoursAgo = "hour(s) ago";
  static const String minutesAgo = "minute(s) ago";
  static const String justNow = 'Just now';
  static const String whoops = 'Whoops!!';
  static const String noInternetConnection =
      'No internet connection was found. Check your connection or try again.';
  static const String tryAgain = 'Try Again';
  static const String keepAtLeast = 'Keep at least';
  static const String daily = 'Daily';
  static const String everyWeek = "Every week";
  static const String every2Weeks = "Every 2 weeks";
  static const String everyMonth = "Every month";
  static const String every3Months = "Every 3 months";
  static const String every6Months = "Every 6 months";
  static const String everyYear = "Every 1 Year";
  static const String selectRecurrence = "Select Recurrence";
  static const String sets = "Set";
  static const String selectDays = "Select Days";
  static const String selectMonths = "Select Months";
  // Units
  static const String days = "Days";
  static const String weeks = "Weeks";
  static const String months = "Months";
  static const String years = "Years";

// Week days
  static const String sunday = "Sun";
  static const String monday = "Mon";
  static const String tuesday = "Tue";
  static const String wednesday = "Wed";
  static const String thursday = "Thu";
  static const String friday = "Fri";
  static const String saturday = "Sat";

// Months
  static const String january = "Jan";
  static const String february = "Feb";
  static const String march = "Mar";
  static const String april = "Apr";
  static const String may = "May";
  static const String june = "Jun";
  static const String july = "Jul";
  static const String august = "Aug";
  static const String september = "Sep";
  static const String october = "Oct";
  static const String november = "Nov";
  static const String december = "Dec";

// Week values
  static const String first = "1st";
  static const String second = "2nd";
  static const String third = "3rd";
  static const String fourth = "4th";
  static const String last = "Last";

// Error messages
  static const String pleaseSelectWeekDay =
      "Please select at least one day of the week.";
  static const String pleaseSelectSpecificDay =
      "Please select a specific day (e.g., 1st, Sun).";
  static const String pleaseSelectMonth = "Please select at least one month.";
  static const String noRoomsAvailable = "No rooms available.";
  static const String goodMorning = "Good Morning";
  static const String goodAfternoon = 'Good Afternoon';
  static const String goodEvening = 'Good Evening';

  ///==================================Employee Section======================
  static const String suggested = 'Suggested';
  static const String searchHint = 'Search here...';
  static const String assignEmployee = 'Assign Employee';
  // static const String selectEmployee = 'Assign Employee';
  static const String pleaseEnterPassword = 'Please enter a password';
  static const String noPendingTasks = "No pending tasks available";

  static const String todayIsYourOffDay = "Today is your off day";
  static const String noOngoingTasksAvailable = "No Ongoing tasks available";
  static const String noCompletedTasksAvailable =
      "No  Completed tasks available";
  static const String groceryTaskDetails = "Grocery task details";
  static const String groceryItems = "Grocery item";
  static const String groceryLoadError = "Failed to load pending groceries";
  static const String noPendingGroceryAvailable =
      "No pending grocery available";
  static const String breakStartTime = "Break Start Time";
  static const String breakEndTime = "Break End Time";
  static const String appetizers = "Appetizers";
  static const String asian = "Asian";
  static const String breakfast = "Breakfast";
  static const String dessert = "Dessert";
  static const String drinks = "Drinks";
  static const String salads = "Salads";
  static const String healthy = "Healthy";
  static const String indian = "Indian";
  static const String snacks = "Snacks";
  static const String lunch = "Lunch";
  static const String meal = "Meal";
  static const String southIndian = "South Indian";

  static const String noHouseSelected = "No House Selected";
  static const String pleaseSelectAHouse =
      "Please select a house before adding a room.";
  static const String pleaseSelectAProfileImage =
      "Please select a profile image.";
  static const String pleaseSelectARecipeImage =
      "Please select a Recipe image.";
  static const String pleaseAddARoomBeforeSaving =
      "Please add a room before saving.";

  static const String addGroceryItem = "Add grocery item";
  static const String selectGroceryItems = 'Select Grocery Items';
  static const String selectTask = 'Select Task';
  static const String searchOrEnterTaskName = "Search or enter task name...";
  static const String selectHouse = "Select House";

  static const String thisDayIsWorkingDay = 'This day is a working day';
  static const String thisDayIsOffDay = 'This day is selected as an off day';
  static const String minimumOneOffDayRequired =
      'Minimum one off day is required';

  static const String passportExpireDate = "Select Expire Date";
  static const String cprExpireDate = "Select Expire Date";
  static const String pleaseEnterLastName = 'Please enter last name';
  static const String employeeFirstName = 'Employee First Name';
  static const String employeeLastName = 'Employee Last Name';
  static const String employeeEmail = 'Employee Email';
  static const String employeePhoneNumber = 'Employee Phone Number';
  static const String employeeDesignation = 'Employee Designation';
  static const String pleaseEnterValidEmail = 'Please enter a valid email';
  static const String pleaseEnterYour = 'Please enter your';
  static const String pleaseEnterYourAddress = 'Please enter your address';
  static const String pleaseEnterYourPhoneNumber =
      'Please enter your phone number';
  static const String pleaseEnterYourDesignation =
      'Please enter your designation';
  static const String pleaseEnterYourFirstName =
      'Please enter your employee first name';
  static const String pleaseEnterYourLastName =
      'Please enter your employee last name';
  static const String pleaseEnterYourEmployeeMail =
      'Please enter your Employee Mail';
  static const String pleaseEnterAValidEmail = 'Please enter a valid email';
  static const String workStartTime = 'Work Start Time';
  static const String workEndTime = 'Work End Time';
  static const String pleaseEnterWorkStartTime = 'Please enter work start time';
  static const String pleaseEnterWorkEndTime = 'Please enter work end time';
  static const String pleaseEnterBreakStartTime =
      'Please enter break start time';
  static const String pleaseEnterBreakEndTime = 'Please enter break end time';
  static const String pleaseEnterPassportNumber =
      'Please enter passport number';
  static const String pleaseEnterPassportExpireDate =
      'Please enter passport expire date';
  static const String pleaseEnterCprNumber = 'Please enter employee cpr number';
  static const String pleaseEnterPhoneNumber =
      'Please enter employee phone number';
  static const String pleaseEnterCprExpireDate = 'Please enter cpr expire date';
  static const String pleaseEnterJobType = 'Please enter job type';
  static const String profileImageIsRequired = "Profile image is required";
  static const String employeeAddress = "Employee Address";
  static const String employeeCPR = "Employee CPR";
  static const String employeePassport = "Employee Passport";
  static const String pleaseEnterValidPhoneNumber =
      'Please enter a valid phone number';
  static const String employeeContactNumber = 'Employee Contact Number';
  static const String pleaseEnterStartTime = 'Please enter start time';
  static const String pleaseEnterEndTime = 'Please enter end time';
  static const String taskStartTime = 'Task Start Time';
  static const String taskEndTime = 'Task End Time';
  static const String pendingShopping = 'Pending Shopping';
  static const String completedShopping = 'Completed Shopping';
  static const String shoppingList = 'Shopping list';
  static const String shopping = 'Shopping';
  static const String shoppingTaskDetails = 'Shopping task details';
  static const String shoppingItem = 'Shopping item';
  static const String addShopping = 'Add Shopping';
  static const String typeIngredient = 'Type Ingredient';
  static const String subscription = 'Subscription';
  static const String freeDays = '7 days free';
  static const String yearlyPackage = "BHD 4 / month";
  static const String monthlyPackage = "BHD 4.99 / month";
  static const String buyNow = 'Buy now';
  static const String newPasswordCannotBeSameAsCurrentPassword =
      "New password cannot be same as current password";
  static const String passwordShouldMatch = "Password should match";
  static const String needHelp = "Need Help?";
  static const String updating = "Updating...";
  static const String howToUse = 'How To Use';
  static const String deleteRoom = 'Delete Room';
  static const String deleteRoomMessage =
      'Are you sure you want to delete this room?';

///=================================
  static const String more="MORE ";
  static const String control="CONTROL";
  static const String less="LESS";
  static const String stress="STRESS";
  static const String timeForWhat="TIME FOR WHAT MATTERS";
  static const String homeManagementSimplified="HOME MANAGEMENT. SIMPLIFIED";
  static const String getStarted="GET STARTED";
  static const String smartHouseholdManagement="SMART HOUSEHOLD MANAGEMENT";
  static const String simplifyYourHome="SIMPLIFY YOUR HOME";
  static const String spaceUpYourLife="SPACE UP YOUR LIFE";
  static const String smartManagement="SMART MANAGEMENT";
  static const String timeForWhatMatters="TIME FOR WHAT MATTERS BOARDING";
  static const String swipeLeft="SWIPE LEFT";
  static const String continueUpper ="CONTINUE";
  static const String chooseYourLanguage ="Choose Your Language";
  static const String chooseYourPlan ="Choose Your Plan";
///=====================================
  static const String skip = "skip";
  static const String plans = "plans";
  static const String sameFeaturesChooseHowYouPay = "Same features. Choose how you pay.";
  static const String yearly = "yearly";
  static const String bestValue = "Best Value";
  static const String sevenDayFreeTrial = "seven_day_free_trial";
  static const String billedAnnually = "billed_annually";
  static const String billedMonthly = "billed_monthly";
  static const String allPlansInclude = "all_plans_include";
  static const String subscribeNow = "subscribe_now";
  static const String maybeLater = "maybe_later";
  static const String subscriptionActive = "subscription_active";
  static const String youHaveActiveSubscription =
      "you_have_active_subscription";
  static const String activePlan = "active_plan";

  // Features
  static const String manageMultipleHouseholds = "manage_multiple_households";
  static const String addUnlimitedStaff = "add_unlimited_staff";
  static const String assignTrackTasks = "assign_track_tasks";
  static const String guidedCleaningRoutines = "guided_cleaning_routines";
  static const String planHouseholdBudget = "plan_household_budget";
  static const String smartShoppingLists = "smart_shopping_lists";
  static const String saveFavoriteRecipes = "save_favorite_recipes";
  static const String sevenDayFree ="7-day free trial";
  static const String sameFeaturesChooseHow ="Same features. Choose how you pay.";
  static const String tapUploadImage ="Tap to upload profile image *";
  static const String chooseYourHouse ="Choose Your House";



}
