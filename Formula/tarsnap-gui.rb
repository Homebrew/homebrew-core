class TarsnapGui < Formula
  desc "Cross-platform GUI for the Tarsnap command-line client"
  homepage "https://github.com/Tarsnap/tarsnap-gui/wiki"
  url "https://github.com/Tarsnap/tarsnap-gui/archive/v1.0.2.tar.gz"
  sha256 "3b271f474abc0bbeb3d5d62ee76b82785c7d64145e6e8b51fa7907b724c83eae"
  license "BSD-2-Clause"
  revision 1
  head "https://github.com/Tarsnap/tarsnap-gui.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "4fd9934a3a064497bfcb361b154dccb74c1cf6343d1b0c40080f1b10f7c061ee"
    sha256 cellar: :any,                 arm64_monterey: "80bebc64d5dad7087f331f5c5e1ebecda9d0ca787903bdb9c233220b53400a5d"
    sha256 cellar: :any,                 arm64_big_sur:  "5143f6dbbb9fadc47420f18716d62135b3e70c4de32e3cef4338c977f0a2d375"
    sha256 cellar: :any,                 ventura:        "b16373c9282a6fc51a9d7e901a082fd287939ce043b19075f09a4f8b67568823"
    sha256 cellar: :any,                 monterey:       "d46639aead1bc9920510f83bb88ca30f6fc58c82235dc4f04037b460582139d6"
    sha256 cellar: :any,                 big_sur:        "5b913f4a300a6694e27a950a473da438dfa2846461466ae0aabc0bee09d2d431"
    sha256 cellar: :any,                 catalina:       "f36b378d5ebee2accc759ec58bd8e554389d606ac7c8b7cf9042ae830b96bc01"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "97b8a8c25cd8383218b698725c2a88cbdb55f161188de94df95406514573d34c"
  end

  depends_on "qt@5"
  depends_on "tarsnap"

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
