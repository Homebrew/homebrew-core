class Xclogparser < Formula
  desc "Tool to parse the SLF serialization format used by Xcode"
  homepage "https://github.com/MobileNativeFoundation/XCLogParser"
  url "https://github.com/MobileNativeFoundation/XCLogParser/archive/refs/tags/v0.2.42.tar.gz"
  sha256 "38f02fc3359b557b4eddb1bd0c12e063858bad19f65171a50c61d7b393b9ec17"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bf0a53497d81f86bcc4e8d75452886563da61dcf6e6e93a678675f3d401bdce6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "622e5798fe8768788e485edcedfec11f6e0fd57e9afbb38e2704d115ff89286b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2f12e89a162b46b953fe975af664deb83e59bb554a8b8661bc0390bc0870d778"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "64bddc1054c263b9a69055fd4f6979af194928fc8c2da52d6e5a26aa1d29ca88"
    sha256 cellar: :any_skip_relocation, sonoma:        "6449046ee960ec4033bb7ea5d021d25967c6a494bfa4d8fccd8e236c748ca0ec"
    sha256 cellar: :any_skip_relocation, ventura:       "2912ff1525c5e8ecd29fc66c01ea0b0b792e8550b56089d014364351a1dbe3c7"
    sha256                               arm64_linux:   "958f12eaebc195dce784e46c2518e9d71918476f20caefe2928c0b4b2ffaed09"
    sha256                               x86_64_linux:  "1a636c81a4dccdf9f84f74eff4abda9baf5da3e3bbd660e961f39a9b1f932a45"
  end

  depends_on xcode: "13.0"

  uses_from_macos "swift"
  uses_from_macos "zlib"

  # patch to use linuxbrew zlib, upstream pr ref, https://github.com/1024jp/GzipSwift/pull/71
  on_linux do
    patch :DATA
  end

  def install
    args = if OS.mac?
      ["--disable-sandbox"]
    else
      ["--static-swift-stdlib"]
    end
    system "swift", "build", *args, "--configuration", "release"
    bin.install ".build/release/xclogparser"
    generate_completions_from_executable(bin/"xclogparser", "--generate-completion-script")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/xclogparser version")

    # skip tests for linux build and sequoia macos build due to the test file issue
    return if OS.linux? || (OS.mac? && MacOS.version == :sequoia)

    resource "homebrew-test_log" do
      url "https://github.com/chenrui333/github-action-test/releases/download/2024.04.14/test.xcactivitylog"
      sha256 "3ac25e3160e867cc2f4bdeb06043ff951d8f54418d877a9dd7ad858c09cfa017"
    end

    resource("homebrew-test_log").stage(testpath)
    output = shell_output("#{bin}/xclogparser dump --file #{testpath}/test.xcactivitylog")
    assert_match "Target 'helloworldTests' in project 'helloworld'", output
  end
end

__END__
diff --git a/Package.resolved b/Package.resolved
index 900fb44..cc4b2bc 100644
--- a/Package.resolved
+++ b/Package.resolved
@@ -11,12 +11,12 @@
         }
       },
       {
-        "package": "Gzip",
+        "package": "GzipSwift",
         "repositoryURL": "https://github.com/1024jp/GzipSwift",
         "state": {
           "branch": null,
-          "revision": "ba0b6cb51cc6202f896e469b87d2889a46b10d1b",
-          "version": "5.1.1"
+          "revision": "29f62534648e6334678b6d7b14c6f7e618715944",
+          "version": null
         }
       },
       {
diff --git a/Package.swift b/Package.swift
index 98f46e7..068b3db 100644
--- a/Package.swift
+++ b/Package.swift
@@ -11,7 +11,7 @@ let package = Package(
         .library(name: "XCLogParser", targets: ["XCLogParser"])
     ],
     dependencies: [
-        .package(url: "https://github.com/1024jp/GzipSwift", from: "5.1.0"),
+        .package(url: "https://github.com/1024jp/GzipSwift", revision: "29f62534648e6334678b6d7b14c6f7e618715944"),
         .package(url: "https://github.com/krzyzanowskim/CryptoSwift.git", .exact("1.3.3")),
         .package(url: "https://github.com/kylef/PathKit.git", from: "1.0.1"),
         .package(url: "https://github.com/apple/swift-argument-parser", from: "1.2.0"),
