class Xclogparser < Formula
  desc "Tool to parse the SLF serialization format used by Xcode"
  homepage "https://github.com/MobileNativeFoundation/XCLogParser"
  url "https://github.com/MobileNativeFoundation/XCLogParser/archive/refs/tags/v0.2.47.tar.gz"
  sha256 "fa4c57c1c60fbfe89897a54c30386c5b1af22e0d224f02acf8bf7bf2f1c4c627"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1d214f8e4b6a5de38a2ae10beb887517cd4eb9ff72eb93416ad89f198d2c35cd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6de2c9a4d3b1a19ba79bd6b57548fd4ed8053b47617c118868be22b9e206280d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "137cabc5277620f119a9d2adbe8308691de878ecd890b28ff627568a974db9eb"
    sha256 cellar: :any_skip_relocation, sonoma:        "fa714bf276c18a40ab2a4cfe3831b49d7593bb2bd5ce2260dbd4c83bddfeaecd"
    sha256                               arm64_linux:   "552f66e10f79bac3b69d64bd0b2f1f39d25f34d91a382b204758f6451d865a96"
    sha256                               x86_64_linux:  "90f1b91b00235f66f525c86aa87f3ef40a9fb69c81ba76e426543a94790ba3c6"
  end

  depends_on xcode: "13.0"

  uses_from_macos "swift"

  on_linux do
    depends_on "zlib-ng-compat"

    # patch to use linuxbrew zlib, upstream pr ref, https://github.com/1024jp/GzipSwift/pull/71
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
