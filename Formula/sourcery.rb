class Sourcery < Formula
  desc "Meta-programming for Swift, stop writing boilerplate code"
  homepage "https://github.com/krzysztofzablocki/Sourcery"
  url "https://github.com/krzysztofzablocki/Sourcery/archive/1.6.0.tar.gz"
  sha256 "34b74a7907d198290dd23cf5a1ad78645ddc4b895144f908e62c06414ee5e959"
  license "MIT"
  head "https://github.com/krzysztofzablocki/Sourcery.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_monterey: "010fd4876fb047ca2bd14feeda78d755987c71ebbd5320d784e585bb37b5779c"
    sha256 cellar: :any, arm64_big_sur:  "17f5cb2a8f9037b2b3a106f1d11783271174a68ab582782b08118b3c51226b07"
    sha256 cellar: :any, monterey:       "0cd3dad2ea6d14c4a50706f7d0640265982dda7aa67cdf8f3ad4d011773bc3bc"
    sha256 cellar: :any, big_sur:        "1d91abe4f760e2a3d232ac1ee3eb24b636a8948049f8f4c4bbb13be4bc2ce072"
  end

  depends_on xcode: "13.0"

  uses_from_macos "ruby" => :build

  def install
    system "rake", "build"
    bin.install "cli/bin/sourcery"
    lib.install Dir["cli/lib/*.dylib"]
  end

  test do
    # Regular functionality requires a non-sandboxed environment, so we can only test version/help here.
    assert_match version.to_s, shell_output("#{bin}/sourcery --version").chomp
  end
end
