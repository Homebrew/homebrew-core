class Xcsift < Formula
  desc "Swift tool to parse xcodebuild output for coding agents"
  homepage "https://ldomaradzki.github.io/xcsift/"
  url "https://github.com/ldomaradzki/xcsift/archive/refs/tags/v1.7.5.tar.gz"
  sha256 "0a0ee7941053ea83e70220f9e478a2d1db10dae957b05baa0c312b2161904fec"
  license "MIT"
  head "https://github.com/ldomaradzki/xcsift.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "093cd9e316fa7527bcde8f6d3bbe7355a3bff5cd8d28e59754e9e6179c7b16f3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "284cf3cc5064cb3fd393c3b78fe159a580077c01b5ddb8ebcdd3927db1fee5d9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1b77d2f8b8103d405bb331b756c390499facdfc7ebcc9253f21a7640a067f1e8"
    sha256 cellar: :any,                 arm64_linux:       "e474510691eae7c2c65200e8ea13311ab3ec78211eb514cd2de8a266d5f7138a"
    sha256 cellar: :any,                 x86_64_linux:      "ade84bd70a0c56cdc9efa63502985557e2d6a299e14a512e12fb58af52d33117"
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
