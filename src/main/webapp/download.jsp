<%@ page language="java" contentType="application/octet-stream; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.*, java.net.URLEncoder"%>
<%@ page import="javax.servlet.http.*" %>
<%@ page import="java.nio.charset.StandardCharsets" %>

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
            // 기본 MIME 타입 설정 (이미지 파일은 이미지로, 텍스트 파일은 텍스트로 지정)
            if (requestedFileName.toLowerCase().endsWith(".jpg") ||
                requestedFileName.toLowerCase().endsWith(".jpeg") ||
                requestedFileName.toLowerCase().endsWith(".png") ||
                requestedFileName.toLowerCase().endsWith(".gif")) {
                mimeType = "image";
            } else if (requestedFileName.toLowerCase().endsWith(".txt")) {
                mimeType = "text/plain";
            } else {
                mimeType = "application/octet-stream";
            }
        }

        // 다운로드를 위한 헤더 설정
        String encodedFileName = URLEncoder.encode(requestedFileName, StandardCharsets.UTF_8.toString());
        response.setContentType(mimeType);
        response.setHeader("Content-Disposition", "attachment; filename=\"" + encodedFileName + "\"");

        // 해당 파일을 그대로 다운로드
        try (OutputStream outputStream = response.getOutputStream();
             FileInputStream fileInputStream = new FileInputStream(requestedFile)) {

            byte[] buffer = new byte[4096];
            int bytesRead;
            while ((bytesRead = fileInputStream.read(buffer)) != -1) {
                outputStream.write(buffer, 0, bytesRead);
            }
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
