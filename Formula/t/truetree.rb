class Truetree < Formula
  desc "Command-line tool for pstree-like output on macOS"
  homepage "https://themittenmac.com/the-truetree-concept/"
  url "https://github.com/themittenmac/TrueTree/archive/refs/tags/v0.7.tar.gz"
  sha256 "56b9cc9983b5a15d0ba2fa8d5cc676368b616336a6a7a2a633a70619d0ff7829"
  license "CC-BY-NC-4.0"

  depends_on xcode: :build
  depends_on :macos

  patch :DATA

  def install
    xcodebuild "-arch", Hardware::CPU.arch, "build"
    sbin.install "build/Release/TrueTree"
  end

  test do
    assert_equal version.to_s, pipe_output("#{sbin}/TrueTree --version").chomp
  end
end

__END__
diff --git a/TrueTree.xcodeproj/project.pbxproj b/TrueTree.xcodeproj/project.pbxproj
index f194ddb..ba942c3 100644
--- a/TrueTree.xcodeproj/project.pbxproj
+++ b/TrueTree.xcodeproj/project.pbxproj
@@ -302,11 +302,11 @@
 				CLANG_ENABLE_MODULES = YES;
 				CLANG_USE_OPTIMIZATION_PROFILE = NO;
 				CODE_SIGN_IDENTITY = "Apple Development";
-				"CODE_SIGN_IDENTITY[sdk=macosx*]" = "Developer ID Application";
+				"CODE_SIGN_IDENTITY[sdk=macosx*]" = "-";
 				CODE_SIGN_INJECT_BASE_ENTITLEMENTS = NO;
 				CODE_SIGN_STYLE = Manual;
 				DEVELOPMENT_TEAM = "";
-				"DEVELOPMENT_TEAM[sdk=macosx*]" = C793NB2B2B;
+				"DEVELOPMENT_TEAM[sdk=macosx*]" = "";
 				ENABLE_HARDENED_RUNTIME = YES;
 				INSTALL_PATH = "";
 				MACOSX_DEPLOYMENT_TARGET = 10.13;
@@ -328,11 +328,11 @@
 				CLANG_ENABLE_MODULES = YES;
 				CLANG_USE_OPTIMIZATION_PROFILE = NO;
 				CODE_SIGN_IDENTITY = "Apple Development";
-				"CODE_SIGN_IDENTITY[sdk=macosx*]" = "Developer ID Application";
+				"CODE_SIGN_IDENTITY[sdk=macosx*]" = "-";
 				CODE_SIGN_INJECT_BASE_ENTITLEMENTS = NO;
 				CODE_SIGN_STYLE = Manual;
 				DEVELOPMENT_TEAM = "";
-				"DEVELOPMENT_TEAM[sdk=macosx*]" = C793NB2B2B;
+				"DEVELOPMENT_TEAM[sdk=macosx*]" = "";
 				ENABLE_HARDENED_RUNTIME = YES;
 				INSTALL_PATH = "";
 				MACOSX_DEPLOYMENT_TARGET = 10.13;
