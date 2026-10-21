class Xcsift < Formula
  desc "Swift tool to parse xcodebuild output for coding agents"
  homepage "https://ldomaradzki.github.io/xcsift/"
  url "https://github.com/ldomaradzki/xcsift/archive/refs/tags/v1.7.0.tar.gz"
  sha256 "0d231c7b7e2db9fc4de259d1b47768f4bcaf3fceb01e1a3aef8469b1b9050a02"
  license "MIT"
  head "https://github.com/ldomaradzki/xcsift.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d82c57ca5f336e346d4d79b5fe792c1933bf460636db63e0fa09dfb1e322a971"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b1d9aaf232a4160eeadce41ddeea68cd19a9614c9fbb5ec9a3da45cdcb528a50"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5975596ee63ddd5adf3fb64cc09197d74b07f1615fa34b0574bd84f617a5603b"
    sha256 cellar: :any,                 arm64_linux:       "e71803e25f8b38320989c87e8a2d65354cbb460e774fb24b4e5e6fd4e4b5567a"
    sha256 cellar: :any,                 x86_64_linux:      "48f66ca9234a06b58a886eada862c37c5f18f23bd7318a294f00d58e073c0a30"
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
