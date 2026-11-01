class Xcsift < Formula
  desc "Swift tool to parse xcodebuild output for coding agents"
  homepage "https://ldomaradzki.github.io/xcsift/"
  url "https://github.com/ldomaradzki/xcsift/archive/refs/tags/v1.7.4.tar.gz"
  sha256 "f2b074654d3125166870b041da34d5fcc75db0adff54e6e0d952cb8caa3f5975"
  license "MIT"
  head "https://github.com/ldomaradzki/xcsift.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "fc226b52141ca74c46fda2ef0ef8c460c119f33e08f6038be114a0ff3b7d7223"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "115f4a5b8189357f8586101e7bcc7df593ebe345a32ae2b4b7373dbae016f9c4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0df975753cf364703563d9c57fa5e29571c5dcadbd7ec16284e4b073f0d495ef"
    sha256 cellar: :any,                 arm64_linux:       "0d55d2d94010477540ea855e829bebef38a3c49e962d0d66fd89c439cb358993"
    sha256 cellar: :any,                 x86_64_linux:      "7f70905c5a5fd7cbcc9610f8fffee81a03a258ecdd2a1ad008319855e1e6b2f7"
  end

  uses_from_macos "swift" => :build, since: :sonoma

  on_macos do
    depends_on xcode: ["16.0", :build]
  end

  deny_network_access!

  def fetch
    system "swift", "package", "resolve", "--disable-sandbox"
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
