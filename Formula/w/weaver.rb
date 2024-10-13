class Weaver < Formula
  desc "Command-line tool for Weaver"
  homepage "https://github.com/scribd/Weaver"
  url "https://github.com/scribd/Weaver/archive/refs/tags/1.1.6.tar.gz"
  sha256 "9ece93166a8fda3c6f1a03ce3a92b46da321420c492b1f7091ca8eed12e45c19"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "03bf5b5e76c95197ccca7802d1641cb0718e032ec33dc1d230654f9d069f9bab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d140adbcced8f4dc5c9435f87e1a046d54c5da572375d094720007cce5379cf9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ae444f345f51ceb5fb13781192bbe2b0ad90b04ed84441b6f7a715018072db09"
    sha256 cellar: :any_skip_relocation, sonoma:        "13b24f6318027d5f943198879212247b5dd10223d030e42dc68760c4a9e915f5"
    sha256 cellar: :any_skip_relocation, ventura:       "387c5ae8c6e1aae6f230b3e36102032b02dec9b69176c05ef813399f849bd791"
  end

  depends_on xcode: ["11.2", :build]

  uses_from_macos "swift"

  conflicts_with "service-weaver", because: "both install a `weaver` binary"

  # Fetch a copy of SourceKitten in order to fix build with newer Swift.
  resource "SourceKitten" do
    on_sequoia :or_newer do
      # https://github.com/scribd/Weaver/blob/1.1.5/Package.resolved#L99-L100
      url "https://github.com/jpsim/SourceKitten.git",
          tag:      "0.29.0",
          revision: "77a4dbbb477a8110eb8765e3c44c70fb4929098f"

      # Backport of import from HEAD
      patch :DATA
    end
  end

  def install
    if OS.mac? && MacOS.version >= :sequoia
      (buildpath/"SourceKitten").install resource("SourceKitten")
      system "swift", "package", "--disable-sandbox", "edit", "SourceKitten", "--path", buildpath/"SourceKitten"
    end

    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    # Weaver uses Sourcekitten and thus, has the same sandbox issues.
    # Rewrite test after sandbox issues investigated.
    # https://github.com/Homebrew/homebrew/pull/50211
    system bin/"weaver", "version"
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
