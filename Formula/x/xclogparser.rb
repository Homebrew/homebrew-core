class Xclogparser < Formula
  desc "Tool to parse the SLF serialization format used by Xcode"
  homepage "https://github.com/MobileNativeFoundation/XCLogParser"
  url "https://github.com/MobileNativeFoundation/XCLogParser/archive/refs/tags/v0.2.44.tar.gz"
  sha256 "bfcf66b7e81ae24bd73a885b13391f544f95bdefa96c22fdb2d3961179d72884"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "14213c5e0b97ed39000bad6a6de9e15fa33b1afe643ccbe1712c490599d09ee7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ec35b1813a456d527dbbe91515f19bc3841dedc519124c44ac816ebd84e8bfca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "53b488143c19e1b003b96773c29db9f99474f9af63b0acfbc067c7d72f5f0f19"
    sha256 cellar: :any_skip_relocation, sonoma:        "e34a400c0f27d0ebfc4062ea02f47502c2fd2e8bd0d5cd7a6a9b2ab3db299ad7"
    sha256                               arm64_linux:   "0d855b250dd2ad1ac65a027944fae9a2865c6d5606fef595cbce8c4ff3575acf"
    sha256                               x86_64_linux:  "d752745f0b3e7aad0d6e08dc7bf0d9afec5d4c5d4eb2357987f3b8b5e2845ce0"
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
      ["--static-swift-stdlib", "-Xswiftc", "-use-ld=ld"]
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
