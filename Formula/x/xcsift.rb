class Xcsift < Formula
  desc "Swift tool to parse xcodebuild output for coding agents"
  homepage "https://ldomaradzki.github.io/xcsift/"
  url "https://github.com/ldomaradzki/xcsift/archive/refs/tags/v1.4.2.tar.gz"
  sha256 "ed7a8a3aba5b24e1d3c6a6bd27396e5f26f452b83484f45122c58142a05be421"
  license "MIT"
  head "https://github.com/ldomaradzki/xcsift.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "44c5c7e287892fe83f77609ce088278a9838d2d6dbc70e2669a870030f7586a4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f22782ffcca14dc1709443d3ef1b8e58d971bf4958dd68da1c654d162455efe0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c749b9eb77197a07bae75528b22c2cfe2f0c2948e89ea31beeeb2c4609df5818"
    sha256 cellar: :any_skip_relocation, sonoma:        "186300c0546362c6252c418eff4cb7b1d19a4b4f167fbccbadcb475650cbcd7f"
    sha256 cellar: :any,                 arm64_linux:   "5a55b3b904aa27ea656a7c9abb440009c276d6826a5ed754051f95d8eeabd75a"
    sha256 cellar: :any,                 x86_64_linux:  "0a0af63860c90f0c6ff95fa001c88549414dd200e00aa9df77b99ebf3f9bd751"
  end

  uses_from_macos "swift" => :build, since: :sonoma

  on_macos do
    depends_on xcode: ["16.0", :build]
  end

  def install
    inreplace "Sources/xcsift/main.swift", "VERSION_PLACEHOLDER", version.to_s

    system "swift", "build", *std_swift_args
    bin.install ".build/release/xcsift"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/xcsift --version")

    output = pipe_output(bin/"xcsift", "Build succeeded")
    assert_match "status", output
    assert_match "summary", output
  end
end
