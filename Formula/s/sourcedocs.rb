class Sourcedocs < Formula
  desc "Generate Markdown files from inline source code documentation"
  homepage "https://github.com/SourceDocs/SourceDocs"
  url "https://github.com/SourceDocs/SourceDocs/archive/refs/tags/2.0.1.tar.gz"
  sha256 "07547c929071124264ec9cc601331f21dc67a104ffc76fbc1801c1ecb4c35bbf"
  license "MIT"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7f04c4c5a56ddc3c0278cc681ae25fd79394ca2c7a24707aa0b7fd347d1bfd8c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b9ee4c05d8785176a69b0eae29935840fe1b185c34195fbf46ec4b45131d61a0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ed67f2afe732b64d633422650be4fd880c01663a74f2ff9d8f84011c0aabbede"
    sha256 cellar: :any_skip_relocation, sonoma:        "5b11c5ec1e62eeb2e0ad0e0db50370f6c4ea66fe94f2b24295db9d550ec7fe6a"
    sha256                               arm64_linux:   "ca3863ed4807fd7b074cc32216319a12ba71bec53d2f21457f5926a4d9000b50"
    sha256                               x86_64_linux:  "b4c07785f740c3bf7741fcdc1bd6a653cbe43d3e0b23405c379db038ad0dac5f"
  end

  uses_from_macos "libxml2"
  uses_from_macos "swift" # runtime as SourceKitten loads sourcekitdInProc

  on_macos do
    depends_on xcode: ["12.0", :build, :test]
  end

  # Workaround until SourceKitten dependency is updated
  # Ref: https://github.com/SourceDocs/SourceDocs/pull/83
  resource "SourceKitten" do
    if DevelopmentTools.clang_build_version >= 1600
      # https://github.com/SourceDocs/SourceDocs/blob/2.0.1/Package.resolved#L32-L38
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

    system "swift", "build", *std_swift_args
    bin.install ".build/release/sourcedocs"
    generate_completions_from_executable(bin/"sourcedocs", "--generate-completion-script")
  end

  test do
    assert_match "SourceDocs v#{version}", shell_output("#{bin}/sourcedocs version")

    # There are some issues with SourceKitten running in sandbox mode in Mojave
    # The following test has been disabled on Mojave until that issue is resolved
    # - https://github.com/Homebrew/homebrew/pull/50211
    # - https://github.com/Homebrew/homebrew-core/pull/32548
    if OS.mac? && MacOS.version < "10.14"
      mkdir "foo" do
        system "swift", "package", "init"
        system "swift", "build", "--disable-sandbox"
        system bin/"sourcedocs", "generate",
               "--spm-module", "foo",
               "--output-folder", testpath/"Documentation/Reference"
        assert_path_exists testpath/"Documentation/Reference/README.md"
      end
    end
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
