class Utiluti < Formula
  desc "Command-line utility to work with default apps"
  homepage "https://github.com/scriptingosx/utiluti"
  url "https://github.com/scriptingosx/utiluti/archive/refs/tags/v1.3.tar.gz"
  sha256 "98d72888421cf048d157da3b64dcc4bdc165c4899de987636a1cac022e5bd7ff"
  license "Apache-2.0"

  depends_on :macos
  depends_on macos: :big_sur

  uses_from_macos "swift" => :build, since: :sonoma # swift 6.0+

  patch :DATA

  def install
    system "swift", "build", "--disable-sandbox", "--configuration", "release"
    system "swift", "package", "--disable-sandbox", "plugin", "generate-manual"

    release_dir = buildpath/".build/release"
    manual_dir = buildpath/".build/plugins/GenerateManual/outputs/utiluti"

    bin.install release_dir/"utiluti"
    man1.install manual_dir/"utiluti.1"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/utiluti --version")
  end
end

__END__
--- a/Sources/utiluti/AppCommands.swift.orig	2025-09-26 21:46:22
+++ b/Sources/utiluti/AppCommands.swift	2025-09-26 21:46:55
@@ -151,7 +151,7 @@
     static let configuration
     = CommandConfiguration(
       commandName: "version",
-      abstract: "Show the version for an app at the path",
+      abstract: "Show the version for an app at the path"
     )
 
     @Argument(help:ArgumentHelp("path to the app", valueName: "path"))
