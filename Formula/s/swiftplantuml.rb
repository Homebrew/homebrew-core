class Swiftplantuml < Formula
  desc "Generate UML class diagrams from Swift sources"
  homepage "https://marcoeidinger.github.io/SwiftPlantUML/"
  url "https://github.com/MarcoEidinger/SwiftPlantUML/archive/refs/tags/0.8.1.tar.gz"
  sha256 "1529dafcfd3e7c20902bee53100a0acee55a80e373d52a208829649dc961e2b0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "03f4d60f46db5f91df82bd3581fb1c56ede43d62eddd7d1f0f0aee010644935b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "7ff206c13b69d39e3f86ac489e8c505cbe7095cf424521692d5b76eeb2393e07"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "494bb09eb5cc7d9dabcfdac317baf2b5939edcbbba51bcde099bea9d1068cb58"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7bdc52a8007de3f0043a220e2a26ace19bdfd906d52b5157a49a1b148466cfc0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c5e3a4d3fe71467bd150d18789322c7cc0a842d54077c6932b173ebee3ab7fd1"
    sha256 cellar: :any_skip_relocation, sonoma:         "cfda85ba53b6afe004e3868e38c8f22c52b397ac215bf05e29d2c68fa45f0960"
    sha256 cellar: :any_skip_relocation, ventura:        "811c2c81ab2d87633a8be92d5553df6aaf36ea6e573759a736a0f2561355c77f"
    sha256 cellar: :any_skip_relocation, monterey:       "d479af32707f10b82e2de01e879e95f6fcfbd4ace0d37c5900823f7873ccdae1"
  end

  depends_on xcode: ["12.2", :build]
  depends_on :macos

  # Fetch a copy of SourceKitten in order to fix build with newer Swift
  resource "SourceKitten" do
    if DevelopmentTools.clang_build_version >= 1600
      # https://github.com/MarcoEidinger/SwiftPlantUML/blob/0.8.1/Package.resolved#L5-L11
      url "https://github.com/jpsim/SourceKitten.git",
          tag:      "0.32.0",
          revision: "817dfa6f2e09b0476f3a6c9dbc035991f02f0241"

      # Backport of import from HEAD
      patch :DATA
    end
  end

  def install
    if DevelopmentTools.clang_build_version >= 1600
      res = resource("SourceKitten")
      (buildpath/"SourceKitten").install res

      pin_version = JSON.parse(File.read("Package.resolved"))
                        .dig("object", "pins")
                        .find { |pin| pin["package"] == "SourceKitten" }
                        .dig("state", "version")
      odie "Check if SourceKitten patch is still needed!" if pin_version != res.version

      system "swift", "package", "--disable-sandbox", "edit", "SourceKitten", "--path", buildpath/"SourceKitten"
    end

    system "make", "install", "prefix=#{prefix}"
  end

  test do
    system bin/"swiftplantuml", "--help"
  end
end

__END__
diff --git a/Source/SourceKittenFramework/SwiftDocs.swift b/Source/SourceKittenFramework/SwiftDocs.swift
index 1d2473c..70de287 100644
--- a/Source/SourceKittenFramework/SwiftDocs.swift
+++ b/Source/SourceKittenFramework/SwiftDocs.swift
@@ -10,6 +10,14 @@
 import SourceKit
 #endif

+#if os(Linux)
+import Glibc
+#elseif os(Windows)
+import CRT
+#else
+import Darwin
+#endif
+
 /// Represents docs for a Swift file.
 public struct SwiftDocs {
     /// Documented File.
