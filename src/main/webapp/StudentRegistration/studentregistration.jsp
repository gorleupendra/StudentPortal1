<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Student Registration Form</title>

<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link
	href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap"
	rel="stylesheet">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
<link rel="stylesheet" href="studentregistration.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/header/style.css">

</head>
<body>
<%@include file="/header/header.jsp" %>
	<main class="main-content">
		<div class="form-container">
			<h2 class="form-title">Student Registration Form</h2>
			<div id="toast"></div>

			<form action="${pageContext.request.contextPath}/studentRegistration" method="post" id="studentForm"
				enctype="multipart/form-data">
				<div class="form-grid">
					<div class="input-group full-width">
						<label for="full-name">Student Name</label>
						<div class="input-wrapper">
							<i class="fa-solid fa-user input-icon"></i><input type="text"
								id="full-name" class="input-field" placeholder="Enter full name"
								required name="fullname">
						</div>
					</div>
					<div class="input-group">
						<label for="father-name">Father's Name</label>
						<div class="input-wrapper">
							<i class="fa-solid fa-user-tie input-icon"></i><input type="text"
								id="father-name" class="input-field"
								placeholder="Enter father's name" required name="fathername">
						</div>
					</div>
					<div class="input-group">
						<label for="regdno">Registration number</label>
						<div class="input-wrapper">
							<i class="fa-solid fa-user-tie input-icon"></i><input type="text"
								id="regdno" class="input-field"
								placeholder="Enter Registration number" required name="regdno">
						</div>
					</div>
					<div class="input-group">
						<label for="mother-name">Mother's Name</label>
						<div class="input-wrapper">
							<i class="fa-solid fa-user-shield input-icon"></i><input
								type="text" id="mother-name" class="input-field"
								placeholder="Enter mother's name" required name="mothername">
						</div>
					</div>

					<div class="input-group">
						<label for="admission-no">Admission Number</label>
						<div class="input-wrapper">
							<i class="fa-solid fa-id-card input-icon"></i><input type="text"
								id="admission-no" class="input-field"
								placeholder="e.g., 25CE...." required name="admno">
						</div>
					</div>
					<div class="input-group">
						<label for="rank">Rank</label>
						<div class="input-wrapper">
							<i class="fa-solid fa-hashtag input-icon"></i><input
								type="number" id="rank" class="input-field"
								placeholder="Enter rank" required name="rank">
						</div>
					</div>
					<div class="input-group">
						<label for="admission-type">Admission Type</label>
						<div class="select-wrapper">
							<select id="admission-type" class="select-field" required
								name="admtype">
								<option value="" disabled selected>----Select Type----</option>
								<option value="Self Finance">Self Finance</option>
								<option value="Self Support">Self Support</option>
								<option value="Management Quota">Management Quota</option>
							</select>
						</div>
					</div>
					<div class="input-group">
						<label for="class">Class</label>
						<div class="select-wrapper">
							<select id="class" class="select-field" required name="class">
								<option value="" disabled selected>----Select Type----</option>
								<option value="M.SC COMPUTERS">M.SC COMPUTERS</option>
								<option value="MCA COMPUTERS">MCA COMPUTERS</option>
								<option value="M.SC APPLIED CHEMISTRY">M.SC APPLIED
									CHEMISTRY</option>
								<option value="MTECH-CSSE">MTECH-CSSE</option>
								<option value="MTECH-ITCA">MTECH-ITCA</option>
								<option value="MTECH-EEE">MTECH-EEE</option>
								<option value="MTECH-ECE">MTECH-ECE</option>
							</select>
						</div>
					</div>
					<div class="input-group">
						<label for="department">Department</label>
						<div class="select-wrapper">
							<select id="department" class="select-field" required name="dept">
								<option value="" disabled selected>----Select Type----</option>
								<option value="CSSE">CSSE</option>
								<option value="ITCA">ITCA</option>
								<option value="ECE">ECE</option>
								<option value="CHEMICAL">CHEMICAL</option>
								<option value="EEE">EEE</option>
								<option value="MECHANICAL">MECHANICAL</option>
								<option value="CIVIL">CIVIL</option>
								<option value="MARINE">MARINE</option>
							</select>
						</div>
					</div>


					<div class="input-group">
						<label for="email">Email Address</label>
						<div class="input-wrapper">
							<i class="fa-solid fa-envelope input-icon"></i><input
								type="email" id="email" class="input-field"
								placeholder="Enter email" required name="email">
						</div>
					</div>
					<div class="input-group">
						<label for="phone">Phone Number</label>
						<div class="input-wrapper">
							<i class="fa-solid fa-phone input-icon"></i><input type="tel"
								id="phone" class="input-field" placeholder="Enter phone"
								required name="phone">
						</div>
					</div>
					<div class="input-group">
						<label for="join-category">Join Category</label>
						<div class="select-wrapper">
							<select id="join-category" class="select-field" required
								name="joincate">
								<option value="" disabled selected>----Select Category----</option>
								<option value="OC">OC</option>
								<option value="BC">BC</option>
								<option value="SC">SC</option>
								<option value="ST">ST</option>
							</select>
						</div>
					</div>
					<div class="input-group">
						<label for="join-category">Joining Year</label>
						<div class="select-wrapper">
						<select id="join-category" class="select-field" name="joinyear" required>
							<option value="" disabled selected>- - - - - year - - - - -</option>
							<option value="2024" >2024</option>
							<option value="2025" >2025</option>
							<option value="2026" >2026</option>
							<option value="2027" >2027</option>
							<option value="2028" >2028</option>
							<option value="2029" >2029</option>
							<option value="2030" >2030</option>
						</select>
						</div>
					</div>
					<div class="input-group full-width">
						<label>Date of Birth</label>
						<div class="dob-inputs">
							<input type="number" id="dob-day" class="dob-field"
								placeholder="DD" min="1" max="31" required name="date">
							<select id="dob-month" class="dob-field" required name="month">
								<option value="" disabled selected>Month</option>
								<option value="01">January</option>
								<option value="02">February</option>
								<option value="03">March</option>
								<option value="04">April</option>
								<option value="05">May</option>
								<option value="06">June</option>
								<option value="07">July</option>
								<option value="08">August</option>
								<option value="09">September</option>
								<option value="10">October</option>
								<option value="11">November</option>
								<option value="12">December</option>
							</select> <select id="dob-year" class="dob-field" required name="year"><option
									value="" disabled selected>- - - - - year - - - - -</option></select>
						</div>
					</div>
					<div class="input-group full-width">
						<label for="gender">Gender</label>
						<div class="select-wrapper">
							<select id="gender" class="select-field" required name="gender">
								<option value="" disabled selected>--------Select
									Gender--------</option>
								<option value="MALE">Male</option>
								<option value="FEMALE">Female</option>
								<option value="OTHERS">Others</option>
							</select>
						</div>
					</div>

					<div class="input-group">
						<label for="village">Village/Town</label>
						<div class="input-wrapper">
							<i class="fa-solid fa-house-chimney input-icon"></i><input
								type="text" id="village" class="input-field"
								placeholder="Enter village or town" required name="village">
						</div>
					</div>
					<div class="input-group">
						<label for="mandal">Mandal</label>
						<div class="input-wrapper">
							<i class="fa-solid fa-map input-icon"></i><input type="text"
								id="mandal" class="input-field" placeholder="Enter mandal"
								required name="mandal">
						</div>
					</div>
					<div class="input-group">
						<label for="district">District</label>
						<div class="input-wrapper">
							<i class="fa-solid fa-city input-icon"></i><input type="text"
								id="district" class="input-field" placeholder="Enter district"
								required name="dist">
						</div>
					</div>
					<div class="input-group">
						<label for="pincode">Pincode</label>
						<div class="input-wrapper">
							<i class="fa-solid fa-location-dot input-icon"></i><input
								type="number" id="pincode" class="input-field"
								placeholder="Enter pincode" required name="pincode">
						</div>
					</div>

					<div class="input-group">
						<label>Student Photo</label> <label for="photo-upload"
							class="file-upload-label" id="photo-upload-label"> <i
							class="fa-solid fa-image"></i><span id="photo-filename">Upload
								a photo</span> <img id="photo-preview" class="file-preview">
						</label> <input type="file" id="photo-upload" class="file-input"
							accept="image/*" name="photo">
					</div>
					<div class="input-group">
						<label>Signature</label> <label for="sign-upload"
							class="file-upload-label" id="sign-upload-label"> <i
							class="fa-solid fa-signature"></i><span id="sign-filename">Upload
								signature</span> <img id="sign-preview" class="file-preview">
						</label> <input type="file" id="sign-upload" class="file-input"
							accept="image/*" name="sign">
					</div>

					<div class="input-group">
						<label for="password">Password</label>
						<div class="input-wrapper">
							<i class="fa-solid fa-lock input-icon"></i><input type="password"
								id="password" class="input-field" placeholder="Min 8 chars"
								minlength="8" required name="password">
						</div>
					</div>
					<div class="input-group">
						<label for="confirm-password">Confirm Password</label>
						<div class="input-wrapper">
							<i class="fa-solid fa-lock input-icon"></i><input type="password"
								id="confirm-password" class="input-field"
								placeholder="Re-enter password" required>
						</div>
						<p class="error-message" id="password-error-message"></p>
					</div>

					<div class="input-group full-width">
						<label for="captcha-input">Captcha</label>
						<div class="captcha-wrapper">
							<div id="captcha-display"></div>
							<button type="button" id="captcha-refresh">
								<i class="fa-solid fa-rotate-right"></i>
							</button>
						</div>
					</div>
					<div class="input-group full-width">
						<div class="input-wrapper">
							<i class="fa-solid fa-keyboard input-icon"></i><input type="text"
								id="captcha-input" class="input-field"
								placeholder="Enter captcha text">
						</div>
						<p class="error-message" id="captcha-error-message"></p>
					</div>

				</div>
				<button type="submit" class="submit-btn full-width">
					<i class="fa-solid fa-user-graduate"></i>Submit
				</button>
			</form>

		</div>
	</main>
	<%@include file="/header/footer.jsp" %>
	<script src="studentregistration.js"></script>
</body>
</html>