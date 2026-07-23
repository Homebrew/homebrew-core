class Xclogparser < Formula
  desc "Tool to parse the SLF serialization format used by Xcode"
  homepage "https://github.com/MobileNativeFoundation/XCLogParser"
  url "https://github.com/MobileNativeFoundation/XCLogParser/archive/refs/tags/v0.2.49.tar.gz"
  sha256 "7b4870794236b061c363fd4b28e7e5a121661ea2c75fc1e92a7a53506b00a58e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ed2998409a0b1f0363ca8639676ea0e71b16e50c60b3bb5fd4e2814c9ae11332"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "05df83f062ed38c2b0704327da31ccf4266244fa64c78c5ad69814277249cc41"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e76998bb0350fb114f70dadbb8862c00f8f0fd0e7a9ba371031a231c1fdd531e"
    sha256 cellar: :any_skip_relocation, sonoma:        "efbc51a1a4268f574a9cbf5ed8b80ec90deb79e277210191b2abff34698a9a18"
    sha256                               arm64_linux:   "4d9f966510b9b91a9458360c11aec9d8e471ab36e97ac5a587f98fdf41e1b18b"
    sha256                               x86_64_linux:  "0670849f06a3fbdcc3ac6bcadd760ee43e9319e1d71aa9e15a102d83cb3ffba7"
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
