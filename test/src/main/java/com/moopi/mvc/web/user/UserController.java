package com.moopi.mvc.web.user;

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.moopi.mvc.service.domain.User;
import com.moopi.mvc.service.moim.impl.MoimServiceImpl;
import com.moopi.mvc.service.user.impl.UserServiceImpl;

import oracle.sql.DATE;

@Controller
@RequestMapping("/user/*")
public class UserController {

	@Autowired
	private UserServiceImpl userService;
	
	@Autowired
	private MoimServiceImpl moimService;
		
	// 카카오 로그인 및 회원가입
	@RequestMapping("kakaoLogin")
	public String kakaoLogin (	@ModelAttribute("user") User user,
								HttpSession session) throws Exception {	
		System.out.println("\n"+"UserRestController_____kakaoLogin 시작");				
		User dbUser = userService.getUser(user.getUserId());		
		// db에 유저값 존재시 addUserInfo로 이동, db에 유저값이 없을 경우 메인페이지 출력		
		if( dbUser != null ) {
			session.setAttribute("dbUser", dbUser);
			return "redirect:/";
		} else {
			user.setJoinPath("4"); // 가입경로 [4.카카오] 지정 후 추가입력페이지 전달
			return "user/addUserInfo";
		}
	}	
	
	// [완료] 로그인페이지 (단순 네비게이션)
	@RequestMapping("loginView")
	public String loginView(@ModelAttribute("user") User user) throws Exception{		
		return "user/loginView";
	}

	// [완료] 로그인 
	@RequestMapping("loginUser")
	public String login(@ModelAttribute("user") User user, 
						HttpSession session) throws Exception{
		User dbUser = userService.loginUser(user.getUserId());
		System.out.println(dbUser);		
		String dbId = user.getUserId();
		String dbPw = user.getPassword();
		
		dbUser = userService.getUser(dbId);	
		if (dbId != null && dbPw.equals(dbUser.getPassword())) {
				System.out.println("아이디 및 비밀번호가 일치합니다.");
				session.setAttribute("dbUser", dbUser);
				return "redirect:/";
			} else {
				System.out.println("아이디 및 비밀번호가 일치하지 않습니다.");
				return "user/loginView";
			}
		}
	

//-- 로그아웃 구현 -------------------------------------------------------------------------------------------
	@RequestMapping("logout")
	public String logout(HttpSession session) throws Exception {
		
		System.out.println("\n"+"UserController_____logout 로그아웃페이지를 띄워주는 단순 네비게이션"+"\n");
		
		// 가입경로 필요없을시 해당 문만 기재하면됨
		session.invalidate();
		System.out.println();
		return "redirect:/";		
	}	
	
//-- [완료] 회원가입 addUserView.jsp로 단순 네비게이션  -------------------------------------------------------------------------------------------
	@RequestMapping("addUserView")
	public String addUserView() throws Exception {			
		return "user/addUserView";
	}
//-----------------------------------------------------------------------------------------------------------------

//-- [완료] addUserView.jsp에서 addUser.jsp로 아이디와 비밀번호(hidden) 담아 네비게이션 ------------------------------------------------------------
	@RequestMapping("addUserInfo")
	public String addUserInfo(@ModelAttribute("user") User user, Model model,
							  @RequestParam("password") String password) throws Exception {
		
		System.out.println("\n"+"UserController_____addUserInfo 시작"+"\n");
		System.out.println("아이디를 담아 추가입력 페이지로 이동하는 네비게이션 역할을 하는 부분입니다.");
		
		model.addAttribute(user);
		return "user/addUserInfo";
	}
//-----------------------------------------------------------------------------------------------------------------

	
//-- [완료] ------------------------------------------------------------
	@RequestMapping("addUser")
	public String addUser (@ModelAttribute("user") User user) throws Exception {
		
		System.out.println("\n"+"UserController_____addUser 시작"+"\n");
		System.out.println("추가정보를 입력받아 회원가입을 마무리 짓는 부분입니다.");

		// Age
		Calendar cal = Calendar.getInstance();	
		int year = cal.get(Calendar.YEAR);
		
		// user의 Birth 출력
		String birth = user.getBirth();
		
		// birth 중 생년만 parsing
		String str = birth;
		String[] num = str.split("-");
		String yy = num[0];
	
		int birthday = Integer.parseInt(yy);
		int age = year - birthday;
		user.setAge(age);
		
		userService.addUser(user);
		
		return "redirect:/";
	}
//-----------------------------------------------------------------------------------------------------------------

	
// [완료] 모바일인증 단순네비게이션
	@RequestMapping("getMobileAuth")
	public String getMobileAuth() throws Exception {
		return "user/getMobileAuth";	
	}

// [완료] 비밀번호찾기
	@RequestMapping("getMobileAuthPW")
	public String getMobileAuthPW(	Model model, @RequestParam("userId") String userId) throws Exception {		
		User id = userService.getUser(userId);
		model.addAttribute("dbUser", id);		
		return "user/getMobileAuth";	
	}
	@RequestMapping("updatePwdViewMobile")
	public String updatePwdViewMobile( @RequestParam("userId") String userId) throws Exception {
		System.out.println("여기로 진입완료");
		return "user/updatePwdViewMobile";
	}
//-- [리턴수정필요] 비밀번호찾기 - 아이디, 모바일번호인증 일치 여부 확인
	@RequestMapping("updatePwdView")
	public String updatePwdView(	@RequestParam("userId") String userId,
									@RequestParam("phone") String phone,								
									User user) throws Exception {
		System.out.println("진입");
		
		System.out.println("회원이 직접 입력한 아이디 : "+userId);
		System.out.println("회원이 직접 입력한 모바일번호 : "+phone);
		
		// 입력한 주소 아이디를 가져옴
		User dbUser = userService.getUser(userId);
		
		System.out.println("dbUser : "+dbUser);
		
		dbUser.getUserId();
		dbUser.getPhone();
		System.out.println("해당 아이디인지 확인 : "+dbUser.getUserId());
		System.out.println("해당 폰넘버인지 확인 : "+dbUser.getPhone());
		
		String getId = dbUser.getUserId();			
		String getPhone = dbUser.getPhone();
		
		System.out.println("db의 Id 확인 : "+getId);
		System.out.println("db의 phone 확인 : "+getPhone);
		
		// 입력한아이디와 입력한 모바일인증번호가 db에 저장되어있는 아이디와 모바일번호가 같다면,
		// 입력한아이디와 db의 아이디
		
		if( dbUser != null) {
			System.out.println("널이아님");
			return "user/updatePwdView";
		} else if (dbUser == null) {
			System.out.println("널");
			return "user/loginView";
		} 

	
		System.out.println("그외");
		return "user/updatePwdView";
	}

//-- searchUserPwd.jsp로 이동하는 단순네비게이션 ------------------------------------------------------------
	@RequestMapping("searchUserPwd")
	public String searchUserPwd() {
			
		System.out.println("UserController_____searchUserPwd 시작");
		System.out.println("비밀번호를 변경을 위한 아이디확인으로 이동하는 단순 네비게이션입니다.");
						
		return "user/searchUserPwd";	
	}
//-----------------------------------------------------------------------------------------------------------------

//	//-- searchUserPwd.jsp로 이동하는 단순네비게이션 ------------------------------------------------------------
//		@RequestMapping("searchUserPwd")
//		public String searchUserPwd(	@RequestParam("userId") String userId,
//										Model model ) throws Exception {
//				
//			System.out.println("UserController_____updateUserPwd 시작");
//			System.out.println("비밀번호를 변경을 위한 아이디확인으로 이동하는 단순 네비게이션입니다.");
//			
//			User user = userService.getUser(userId);
//			model.addAttribute("dbUser", user);
//							
//			return "user/searchUserPwd";	
//		}
//	//-----------------------------------------------------------------------------------------------------------------
		
	
//-- getMyHomeBoard.jsp로 이동하는 단순네비게이션 ------------------------------------------------------------
//	@RequestMapping("getMyHomeBoard")
//	public String getMyHomeBoard() throws Exception {
//			
//		System.out.println("UserController_____searchUserPwd 시작");
//		System.out.println("비밀번호를 찾기위한 아이디확인으로 이동하는 단순 네비게이션입니다.");
//				
//		return "user/getMyHomeBoard";	
//	}
//-----------------------------------------------------------------------------------------------------------------

//-- getMyHomeBoard.jsp  ------------------------------------------------------------

	@RequestMapping("getMyHome")
	public String getUser(@RequestParam("userId") String userId, HttpSession session, Model model) throws Exception {
		
		System.out.println(userService.getUser(userId));
		
		System.out.println("\n"+"1 : UserController_____getMyHomeBoard 시작"+"\n");
		System.out.println("마이홈의 메인을 출력하는 페이지입니다. 여러 값들을 가져와야 하는 부분");		
		
		// ! 세션이 존재하기에 초기화됨
		//model.addAttribute("dbUser",userService.getUser(userId));
		
		// 코인, 팔로잉, 게시판, 모임에서 사용해야하니 CommonRestController 보고 작성해보
		
		System.out.println("여기도 확인해보자 : "+userId);
		System.out.println("겟마이홈보드에서 model.addAttribute(user)를 불러오면? : "+userId);
		// 로그인유저 확인해보기 loginUser
		System.out.println(userService.getUser(userId));
		
		
		/////// 추가부분
		User user = (User)session.getAttribute("dbUser");
		
		// 팔로우 유무체크
		boolean check = false;
		if(user != null) {
			if(userService.getFollow(user.getUserId(), userId) != null) {
				check = true;
			}
		}
		
		System.out.println("ddddddd"+moimService.getMyMoimList(userId).get("list"));
		
		model.addAttribute("user", userService.getUser(userId));
		model.addAttribute("moim", moimService.getMyMoimList(userId).get("list2"));
		model.addAttribute("folloingCount", userService.getFollowCount(userId, 1));
		model.addAttribute("followerCount", userService.getFollowCount(userId, 2));
		model.addAttribute("followCheck", check);
		///////
		return "user/getMyHome";
	}	
////-----------------------------------------------------------------------------------------------------------------

	
//-- [완료] 프로필수정 (단순 네비게이션) -------------------------------------------------------------------------------------------
	@RequestMapping("updateProfile")
	public String updateProfile(@RequestParam("userId") String userId,
								@ModelAttribute("user") User user,
								Model model) throws Exception{
				
		System.out.println("\n"+"UserController_____updateProfile 프로필수정 페이지"+"\n");

		model.addAttribute("dbUser",userService.getUser(userId));
		
		System.out.println(userService.getUser(userId));
		return "user/updateProfile";
		
	}
//-----------------------------------------------------------------------------------------------------------------	

//// 계정정보수정
//	@RequestMapping("updateUserViewupdateUserView")
//	public void updateUserView( 	@RequestParam("userId") String userId,
//									@RequestParam("phone") String phone,
//									@RequestParam("password") String password,
//									User user) throws Exception {
//		user.getUserId();
//		user.getPhone();
//		user.getPassword();
//		
//		userService.updateUserView(user);
//		
//		user.setPhone(phone);
//		user.setPassword(password);
//	
//	}
	
//	@RequestMapping("updateNickname")
//	public String updateUser(	@RequestParam("userId") String userId,
//								@RequestParam("nickname") String nickname,
//									@ModelAttribute("user") User user,
//									Model model) throws Exception {
//				
//		System.out.println("\n"+"UserRestController_____updateNickname 시작");
//		
//		user.setNickname(nickname);
//		System.out.println("변경해서 데리고 온 닉네임 확인하기 : "+nickname);
//		
//		System.out.println("데려온 userId : "+user.getUserId());
//		System.out.println("데려온 nickname : "+user.getNickname());
//
//		userService.updateUser(user);
//		System.out.println("변경되었는지 확인해보기 : "+user);
//		
//		model.addAttribute(nickname, user);
//		System.out.println("모델로 두었을 떄 변경되었는지 확인해보기 : "+user);
//		
////		user.getUser(user.getUserId());
////		user.addAttribute("nickname", user);
//		System.out.println("이것도 확인 : "+user.getUserId());
////		System.out.println("두번째 확인 : "+model.addAttribute("nickname", user));
//		return "user/updateUser";				
//	}

// [프로필 업데이트]-----------------------------------------------------------------------------------------------	
	

	// 1. [닉네임수정] - updateNickname
//	@RequestMapping("updateNickname")
//	public String updateNickname(	@RequestParam("userId") String userId,
//									@RequestParam("nickname") String nickname,
//									@ModelAttribute("user") User user) {
//		System.out.println("닉네임수정");		
//		userService.updateNickname(user);
//		return "user/updateUser";				
//	}
	
	// 2. [프로필소개수정] - updateContent
	@RequestMapping("updateContent")
	public String updateContent(	@RequestParam("userId") String userId,
									@RequestParam("profileContent") String profileContent,
									@ModelAttribute("user") User user) {
		System.out.println("프로필소개수정");		
		userService.updateContent(user);
		return "user/updateContent";				
	}
		
	// 3. [관심사수정] - updateInterest
	@RequestMapping("updateInterest")
	public String updateInterest(	@RequestParam("userId") String userId,
									@RequestParam("interestFirst") String interestFirst,
									@RequestParam("interestSecond") String interestSecond,
									@RequestParam("interestThird") String interestThird,
									@ModelAttribute("user") User user) {
		System.out.println("관심사수정");		
		userService.updateInterest(user);
		return "user/updateInterest";				
	}
	
	// 회원탈퇴
	@RequestMapping("updateLeaveUser")
	public String updateLeaveUser (	@RequestParam("userId") String userId,
									@RequestParam("userRole") String userRole,
									@RequestParam("stateReason") String stateReason,
									HttpSession session,
									Model model) throws Exception {		
		User user = new User();
		user.setUserId(userId);
		user.setStateReason(stateReason);		
		model.addAttribute("dbUser", userId);
		model.addAttribute("dbUser", stateReason);		
		userService.updateLeaveUser(user);	
		session.invalidate();
		return "redirect:/";
	}


//-- [완료] 회원가입 addUserView.jsp로 단순 네비게이션  -------------------------------------------------------------------------------------------
	@RequestMapping("getIdView")
	public String getIdView() throws Exception {
		
		System.out.println("UserController_____getIdView 시작");
		System.out.println("아이디찾기 진행시 아이디를 띄워주는 뷰입니다.");
				
		return "user/getIdView";
	}
//-----------------------------------------------------------------------------------------------------------------
	
//-- 아이디찾기 -------------------------------------------------------------------------------------------
	@RequestMapping("searchIdView")
	public String searchIdView(	@RequestParam("phone") String phone,
								Model model,
								@ModelAttribute("user") User user) throws Exception{		
		
		model.addAttribute("dbUser", userService.getId(phone));			
		
		
		User dbUser = userService.getId(user.getPhone());		
		
		if (dbUser == null) {
			System.out.println("널임");
		} else if (dbUser != null) {
			System.out.println("널이아님");
		}		
		
		return "user/searchIdView";
		}
//-----------------------------------------------------------------------------------------------------------------
	@RequestMapping("googleLogin")
	public String googleLogin (	@ModelAttribute("user") User user, 
								HttpSession session) throws Exception {			
		User googleId = userService.getUser(user.getUserId());	
		if( googleId != null ) {
			session.setAttribute("user", googleId);
			return "redirect:/";
		} else {
			return "user/addUserInfo";
		}
	}	
	
//-- [완료] 회원가입 addUserView.jsp로 단순 네비게이션  -------------------------------------------------------------------------------------------
	@RequestMapping("updateUserView")
	public String updateUserView( @RequestParam("userId") String userId, Model model ) throws Exception {
		
		model.addAttribute("dbUser", userService.getUser(userId));
			
		System.out.println("UserController_____getIdView 시작");
		System.out.println("아이디찾기 진행시 아이디를 띄워주는 뷰입니다.");
					
		return "user/updateUserView";
	}
//-----------------------------------------------------------------------------------------------------------------
	@RequestMapping("updateUser")
	public void updateUser ( 	@RequestParam("userId") String userId, 
								@RequestParam("password") String password,
								@RequestParam("phone") String phone,
								Model model, User user) throws Exception {
		
		user.setPassword(password);
		user.setPhone(phone);
		
		userService.updateUser(user);
	}
	
	@RequestMapping(value="myInformation")
	public String myInformation() {
		
		System.out.println("myInformation 시작");
		return "user/myInformation";
	}
	
	@RequestMapping("test")
	public String test() {
		
		System.out.println("myInformation 시작");
		return "user/test";
	}
	
	
	
	
}
