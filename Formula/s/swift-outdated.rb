class SwiftOutdated < Formula
  desc "Check for outdated Swift package manager dependencies"
  homepage "https://github.com/kiliankoe/swift-outdated"
  url "https://github.com/kiliankoe/swift-outdated/archive/refs/tags/0.15.3.tar.gz"
  sha256 "1f327a5798609707bd2b5a303eb33b4f3d1e0f240e5e27c239be11df1084203b"
  license "MIT"
  head "https://github.com/kiliankoe/swift-outdated.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "19959cded6d835f1dd5a383a838e6f74f6eebb8f36a68cff4ecbb7cc671beba3"
    sha256 cellar: :any,                 arm64_sequoia: "1a1a83f7efeacb7a082d9d8b95f0850a91813672daaa8079ce9298620e0ca846"
    sha256 cellar: :any,                 arm64_sonoma:  "78b243beec32bf5229a9b749d975b1ed6b5e91726d1eb3a31ddb4200b967b8a9"
    sha256 cellar: :any,                 sonoma:        "611cba1ddd9be942c3e0df02d87f4aceefe6a66cd8b978bdea0bfc3f1fcd0a65"
    sha256 cellar: :any,                 arm64_linux:   "cb12cd2c7821d3b54283557a605bdbd6bf8452c85ed2e6f22f111751adff09d3"
    sha256 cellar: :any,                 x86_64_linux:  "050c92f487d9c05765ffbdf70d2fdc6f68589b1494b97fcc001b302677b65e28"
  end

  uses_from_macos "swift" => :build, since: :tahoe # swift 6.2+
  uses_from_macos "curl"

  def install
    inreplace "Sources/SwiftOutdated/SwiftOutdated.swift", "dev", version.to_s

    args = if OS.mac?
      ["--disable-sandbox"]
    else
      ["--static-swift-stdlib", "-Xlinker", "-L#{formula_opt_lib("curl")}"]
    end
    system "swift", "build", *args, "-c", "release"
    bin.install ".build/release/swift-outdated"
    generate_completions_from_executable(bin/"swift-outdated", "--generate-completion-script")
  end

  test do
    assert_match "No Package.resolved found", shell_output("#{bin}/swift-outdated 2>&1", 1)
    assert_match version.to_s, shell_output("#{bin}/swift-outdated --version")
  end
end
