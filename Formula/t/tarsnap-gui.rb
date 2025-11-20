class TarsnapGui < Formula
  desc "Cross-platform GUI for the Tarsnap command-line client"
  homepage "https://www.tarsnap.com/"
  url "https://github.com/Tarsnap/tarsnap-gui/archive/refs/tags/v1.0.2.tar.gz"
  sha256 "3b271f474abc0bbeb3d5d62ee76b82785c7d64145e6e8b51fa7907b724c83eae"
  license "BSD-2-Clause"
  revision 1
  head "https://github.com/Tarsnap/tarsnap-gui.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:    "bd02f77a05c961179c8cd9c080367dd5792305a26b840bfb4aa5584dedc267d6"
    sha256 cellar: :any,                 arm64_sequoia:  "c9cddf5f7eb1d96d77deabf95a9633bdc7fbc649f8349e6960db1f071346e34a"
    sha256 cellar: :any,                 arm64_sonoma:   "219f6ec9f2c36912eaca916110b5ddbb59b7da0285ecee28a73e31023347dad5"
    sha256 cellar: :any,                 arm64_ventura:  "4fd9934a3a064497bfcb361b154dccb74c1cf6343d1b0c40080f1b10f7c061ee"
    sha256 cellar: :any,                 arm64_monterey: "80bebc64d5dad7087f331f5c5e1ebecda9d0ca787903bdb9c233220b53400a5d"
    sha256 cellar: :any,                 arm64_big_sur:  "5143f6dbbb9fadc47420f18716d62135b3e70c4de32e3cef4338c977f0a2d375"
    sha256 cellar: :any,                 sonoma:         "0bcca07b474c99ee8db92f57a79d5fcff7efd952a5833fca445863a5d099d60b"
    sha256 cellar: :any,                 ventura:        "b16373c9282a6fc51a9d7e901a082fd287939ce043b19075f09a4f8b67568823"
    sha256 cellar: :any,                 monterey:       "d46639aead1bc9920510f83bb88ca30f6fc58c82235dc4f04037b460582139d6"
    sha256 cellar: :any,                 big_sur:        "5b913f4a300a6694e27a950a473da438dfa2846461466ae0aabc0bee09d2d431"
    sha256 cellar: :any,                 catalina:       "f36b378d5ebee2accc759ec58bd8e554389d606ac7c8b7cf9042ae830b96bc01"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "bc5bf08c24dc5dc1a85d550744ff823086e32076300936f9462ca6b0857db88f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "97b8a8c25cd8383218b698725c2a88cbdb55f161188de94df95406514573d34c"
  end

  # Last release on 2018-08-23
  # Can undeprecate if new release with Qt 6 support is available.
  deprecate! date: "2026-05-19", because: "needs end-of-life Qt 5"

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
