class Sourcery < Formula
  desc "Meta-programming for Swift, stop writing boilerplate code"
  homepage "https://github.com/krzysztofzablocki/Sourcery"
  url "https://github.com/krzysztofzablocki/Sourcery/archive/1.3.2.tar.gz"
  sha256 "e0445528cff1d11bbe65d2b8a3388a01aa7732f2fce49e3e0099aed6f2192c98"
  license "MIT"
  head "https://github.com/krzysztofzablocki/Sourcery.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "596cca6369ad1c82202aedb778de34637139e9ef5d2d8ff9ea33c8c218e94031"
    sha256 cellar: :any, big_sur:       "a40e864a311323a8039c9db6f359182e59a72e27759a6a661134ff44f26417e1"
    sha256 cellar: :any, catalina:      "e049eabdb72e1199e0468daa6052f7685944bfec99a5416653466f1dabdf0d8c"
  end

  depends_on xcode: "12.0"
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
