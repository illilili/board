<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page
	import="java.io.*, java.net.URLEncoder, java.util.zip.ZipEntry, java.util.zip.ZipOutputStream"%>
<%@ page import="javax.servlet.http.*"%>
<%@ page import="java.sql.DriverManager"%>

<%
// 폴더 경로
String folderPath = "C:/eGovFrameDev-4.1.0-64bit/workspace/ipp/upload/";

// Get the file name parameter from the request
String requestedFileName = request.getParameter("fileName");

if (requestedFileName != null && !requestedFileName.isEmpty()) {
	File requestedFile = new File(folderPath + requestedFileName);

	if (requestedFile.exists() && requestedFile.isFile()) {
		// MIME 타입 설정
		String mimeType = getServletContext().getMimeType(requestedFileName);
		if (mimeType == null) {
	mimeType = "application/octet-stream";
		}

		// 다운로드를 위한 헤더 설정
		response.setContentType(mimeType);
		response.setHeader("Content-Disposition",
		"attachment; filename=\"" + URLEncoder.encode(requestedFileName, "UTF-8") + "\"");

		// 해당 파일을 압축 파일로 다운로드
		try (ZipOutputStream zipOutputStream = new ZipOutputStream(response.getOutputStream())) {
	byte[] buffer = new byte[4096];

	// 압축 파일 내의 엔트리 생성
	zipOutputStream.putNextEntry(new ZipEntry(requestedFileName));

	// 파일을 읽고 압축 파일에 쓰기
	try (InputStream inputStream = new FileInputStream(requestedFile)) {
		int bytesRead;
		while ((bytesRead = inputStream.read(buffer)) != -1) {
			zipOutputStream.write(buffer, 0, bytesRead);
		}
	}
	// 압축 파일 닫기
	zipOutputStream.closeEntry();
		} catch (IOException e) {
	e.printStackTrace();
		}
	} else {
		// 해당 파일이 존재하지 않는 경우에 대한 처리
		response.getWriter().println("다운로드할 파일을 찾을 수 없습니다.");
	}
} else {
	// 파일 이름을 요청 파라미터로 받지 못한 경우에 대한 처리
	response.getWriter().println("파일 이름을 찾을 수 없습니다.");
}
%>
