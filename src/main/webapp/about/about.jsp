<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>About M.Sc. CS - University Portal</title>
    
    <%-- Fonts and Icons --%>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    
    <%-- Stylesheets --%>
    <%-- Main layout from header folder --%>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/header/style.css"> 
    <%-- Specific styles for this page --%>
    <link rel="stylesheet" href="about.css">
    
</head>
<body>

    <%-- Include the header --%>
    <%@ include file="/header/header.jsp" %>

    <%-- Main content area --%>
    <main class="main-content">
        <div class="about-container">
            
            <!-- Header Section -->
            <div class="program-header">
                <i class="fa-solid fa-laptop-code"></i>
                <h1>M.Sc. Computer Science – ITCA Department</h1>
                <p>A postgraduate programme designed to build strong theoretical and practical knowledge in Computer Science.</p>
            </div>
        
            <!-- About the Programme -->
            <h2><i class="fa-solid fa-graduation-cap"></i> About the Programme</h2>
            <ul class="program-details">
                <li>Offered by the Department of Information Technology and Computer Applications (ITCA), Andhra University College of Engineering.</li>
                <li>Focuses on modern computing technologies, software development, and research-oriented learning.</li>
            </ul>
        
            <!-- Programme Objectives -->
            <h2><i class="fa-solid fa-lightbulb"></i> Programme Objectives</h2>
            <ul class="program-details check-list">
                <li>To equip students with advanced computing, programming, and analytical skills.</li>
                <li>To develop problem-solving abilities for designing intelligent and efficient software solutions.</li>
                <li>To prepare graduates for software industry roles, research careers, and competitive exams like UGC NET and GATE.</li>
                <li>To encourage innovation, critical thinking, and lifelong learning in the field of computer science.</li>
            </ul>
        
            <!-- Key Areas of Study -->
            <h2><i class="fa-solid fa-brain"></i> Key Areas of Study</h2>
            <ul class="program-details grid-list">
                <li>Data Structures and Algorithms</li>
                <li>Database Management Systems (DBMS)</li>
                <li>Operating Systems and Computer Networks</li>
                <li>Artificial Intelligence and Machine Learning</li>
                <li>Software Engineering and Testing</li>
                <li>Compiler Design and Automata Theory</li>
                <li>Web Technologies and Cloud Computing</li>
                <li>Data Mining and Big Data Analytics</li>
            </ul>
        
            <!-- Salient Features -->
            <h2><i class="fa-solid fa-puzzle-piece"></i> Salient Features</h2>
            <ul class="program-details check-list">
                <li>Curriculum aligned with current industry trends and research advancements.</li>
                <li>Experienced faculty and well-equipped computer laboratories.</li>
                <li>Opportunity for minor and major projects to gain real-world experience.</li>
                <li>Integration of theoretical knowledge with hands-on practice.</li>
                <li>Encourages interdisciplinary learning and innovation.</li>
                <li>Supports NET, GATE, and higher education preparation through academic depth.</li>
            </ul>
        
            <!-- Career Opportunities -->
            <h2><i class="fa-solid fa-briefcase"></i> Career Opportunities</h2>
            <ul class="program-details grid-list">
                <li>Software Developer / Programmer</li>
                <li>Data Analyst / Database Administrator</li>
                <li>Web and Cloud Application Developer</li>
                <li>Research Assistant / Junior Research Fellow</li>
                <li>Assistant Professor (after UGC NET qualification)</li>
                <li>IT Consultant / System Analyst</li>
            </ul>
        
            <!-- Why Choose M.Sc. ... -->
            <h2><i class="fa-solid fa-school"></i> Why Choose M.Sc. Computer Science at AUCE</h2>
            <ul class="program-details check-list">
                <li>Part of a prestigious NAAC-A+ accredited university with decades of excellence.</li>
                <li>Department established in 2018-19 with focus on emerging technologies.</li>
                <li>Balanced exposure to industry and academic research.</li>
                <li>Encourages participation in workshops, internships, and technical events.</li>
                <li>Provides strong foundation for software careers and research pursuits.</li>
            </ul>
        
            <!-- Vision -->
            <h2><i class="fa-solid fa-seedling"></i> Vision</h2>
            <p>To produce skilled, innovative, and research-oriented computer professionals capable of contributing to technological growth and academic excellence.</p>

            <!-- NEW: Photo Gallery Section -->
            <h2><i class="fa-solid fa-camera-retro"></i> Photo Gallery</h2>
            <div class="photo-gallery">
                
                <img src="https://i.postimg.cc/Z559PmvY/4.jpg" 
                     alt="Computer Lab" 
                     onerror="this.src='https://placehold.co/800x400/1f2937/white?text=Image+Not+Found'">
                <img src="https://i.postimg.cc/Nf3sFw8x/cse.jpg" 
                     alt="Computer Lab" 
                     onerror="this.src='https://placehold.co/800x400/1f2937/white?text=Image+Not+Found'">
                <img src="https://i.postimg.cc/5Nssxxwj/MAN02662-342129290.jpg" 
                     alt="University Campus" 
                     onerror="this.src='https://placehold.co/800x400/3b82f6/white?text=Image+Not+Found'">
                     
                <img src="https://i.postimg.cc/6Q34LXSC/MAN02945-2029073282.jpg" 
                     alt="Modern Classroom" 
                     onerror="this.src='https://placehold.co/800x400/6b7280/white?text=Image+Not+Found'">
                     
                <img src="https://i.postimg.cc/3x73HFFx/MAN02953-2002291173.jpg" 
                     alt="Lecture Hall" 
                     onerror="this.src='https://placehold.co/800x400/3b82f6/white?text=Image+Not+Found'">
                <img src="https://i.postimg.cc/SQ684qBf/12.jpg" 
                     alt="Lecture Hall" 
                     onerror="this.src='https://placehold.co/800x400/3b82f6/white?text=Image+Not+Found'">
            </div>
            
        </div>
    </main>

    <%-- Include the footer --%>
    <%@ include file="/header/footer.jsp" %>

</body>
</html>

