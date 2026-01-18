class Xcsift < Formula
  desc "Swift tool to parse xcodebuild output for coding agents"
  homepage "https://github.com/ldomaradzki/xcsift"
  url "https://github.com/ldomaradzki/xcsift/archive/refs/tags/v1.0.22.tar.gz"
  sha256 "eb37820fd006a25a588463ace2e05ac550abaa5974bd7e74bf6612aad19f2d21"
  license "MIT"
  head "https://github.com/ldomaradzki/xcsift.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3fbb9c3f3370c529a0d9dd20e0db9df4dc23b8fab855ff0077f17f184aab329b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "49436f3c01c7af870fb86898ad110e9fcbf3152d17c82846a19952cc4d789f3f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b03032b8dae5134379c5c4e667d841668813668470f9d2d8a7abeb3cbe81ca4f"
    sha256 cellar: :any_skip_relocation, sonoma:        "b0ef63274f0f61f0804e9ea35d6a06738b035dcecc4dab26d6496a8fcc76aa67"
  end

  depends_on xcode: ["16.0", :build]
  depends_on :macos

  def install
    inreplace "Sources/main.swift", "VERSION_PLACEHOLDER", version.to_s
    system "swift", "build", "--disable-sandbox", "-c", "release"
    bin.install ".build/release/xcsift"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/xcsift --version")

    output = pipe_output(bin/"xcsift", "Build succeeded")
    assert_match "status", output
    assert_match "summary", output
  end
end
