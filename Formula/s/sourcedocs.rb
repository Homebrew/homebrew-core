class Sourcedocs < Formula
  desc "Generate Markdown files from inline source code documentation"
  homepage "https://github.com/SourceDocs/SourceDocs"
  url "https://github.com/SourceDocs/SourceDocs/archive/refs/tags/2.0.1.tar.gz"
  sha256 "07547c929071124264ec9cc601331f21dc67a104ffc76fbc1801c1ecb4c35bbf"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c4ece7ed5a98c8df2e5e4589c10559f8ed042a413da225b2ca7eb051fe0da7ef"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "469c4069a84bcc4e8ed58db567eeca9bb8d13311b0c3b5d289bd61a9d1a09aba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b7cb1a6469f057e769fd3ea2e22e2a288b16d42a7b44a3688e1f0787288e6fa2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "54139f452dcce5a6bb3d42f6483a1ddab9a97705b1b07d89f70333e9a0a770dc"
    sha256 cellar: :any_skip_relocation, sonoma:        "55d0026d803e708bd167e4817a0f278f0bc0b393103711c0fdc1db59f2ce5063"
    sha256 cellar: :any_skip_relocation, ventura:       "4b08ada0cacbbfde31cdf88bfc10aba963442a03363844c888c39d9cd6d8862c"
    sha256                               arm64_linux:   "7698fc8b57805896688c2e9058fb25e4aa7f6189f4252e8d253a02662e98321b"
    sha256                               x86_64_linux:  "2c97cd8daa81d7c7e546e71cdfdf17db555dee5260d434287266f20edb3a25a6"
  end

  depends_on xcode: ["12.0", :build, :test]
  uses_from_macos "swift"

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
    args = ["--disable-sandbox", "--configuration", "release"]
    if DevelopmentTools.clang_build_version >= 1600
      res = resource("SourceKitten")
      (buildpath/"SourceKitten").install res

      pin_version = JSON.parse(File.read("Package.resolved"))
                        .dig("object", "pins")
                        .find { |pin| pin["package"] == "SourceKitten" }
                        .dig("state", "version")
      odie "Check if SourceKitten patch is still needed!" if pin_version != res.version

      system "swift", "package", *args, "edit", "SourceKitten", "--path", buildpath/"SourceKitten"
    end

    system "swift", "build", *args
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
