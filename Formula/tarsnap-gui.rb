class TarsnapGui < Formula
  desc "Cross-platform GUI for the Tarsnap command-line client"
  homepage "https://github.com/Tarsnap/tarsnap-gui/wiki"
  url "https://github.com/Tarsnap/tarsnap-gui/archive/v1.0.2.tar.gz"
  sha256 "3b271f474abc0bbeb3d5d62ee76b82785c7d64145e6e8b51fa7907b724c83eae"
  license "BSD-2-Clause"
  revision 1
  head "https://github.com/Tarsnap/tarsnap-gui.git", branch: "master"

  # Linux bottle removed for GCC 12 migration
  bottle do
    sha256 cellar: :any,                 arm64_monterey: "f8f2504a74299c6fbcc41df3811498f6d4f8716ade39165f5fb8a2e611ae0aac"
    sha256 cellar: :any,                 arm64_big_sur:  "0e8def1a5aad31ebe64570260d5c622bd350880034c26d35c0d564b2bda46a98"
    sha256 cellar: :any,                 monterey:       "807c80d7626a0e7c1bb318e379e1e5fffe32d1f80bda8cf2cd09063434c0d447"
    sha256 cellar: :any,                 big_sur:        "caa57be13fe93093dfd6fd275d7648f181db9508064308267bd3d5883974d00c"
    sha256 cellar: :any,                 catalina:       "84c04aa45fbc4620b074386f5238731ad053e95b17309e27ce923c9e0439b3c0"
  end

  depends_on "qt@5"
  depends_on "tarsnap"

  fails_with gcc: "5" # qt@5 is built with GCC

  # Work around build error: Set: Entry, ":CFBundleGetInfoString", Does Not Exist
  # Issue ref: https://github.com/Tarsnap/tarsnap-gui/issues/557
  patch :DATA

  def install
    system "qmake"
    system "make"
    if OS.mac?
      prefix.install "Tarsnap.app"
      bin.install_symlink prefix/"Tarsnap.app/Contents/MacOS/Tarsnap" => "tarsnap-gui"
    else
      bin.install "tarsnap-gui"
    end
  end

  test do
    # Set QT_QPA_PLATFORM to minimal to avoid error "could not connect to display"
    ENV["QT_QPA_PLATFORM"] = "minimal" if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]
    system bin/"tarsnap-gui", "--version"
  end
end

__END__
diff --git a/Tarsnap.pro b/Tarsnap.pro
index 9954fc5c..560621b1 100644
--- a/Tarsnap.pro
+++ b/Tarsnap.pro
@@ -131,5 +131,8 @@ osx {
 
     # Add VERSION to the app bundle.  (Why doesn't qmake do this?)
     INFO_PLIST_PATH = $$shell_quote($${OUT_PWD}/$${TARGET}.app/Contents/Info.plist)
-    QMAKE_POST_LINK += /usr/libexec/PlistBuddy -c \"Set :CFBundleGetInfoString $${VERSION}\" $${INFO_PLIST_PATH} ;
+    QMAKE_POST_LINK += /usr/libexec/PlistBuddy \
+                            -c \"Add :CFBundleVersionString string $${VERSION}\" \
+                            -c \"Add :CFBundleShortVersionString string $${VERSION}\" \
+                            $${INFO_PLIST_PATH} ;
 }
