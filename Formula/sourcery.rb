class Sourcery < Formula
  desc "Meta-programming for Swift, stop writing boilerplate code"
  homepage "https://github.com/krzysztofzablocki/Sourcery"
  url "https://github.com/krzysztofzablocki/Sourcery/archive/1.0.3.tar.gz"
  sha256 "af6e3549fba9b734a667343f5b888f2226e9a2e4e462fe81bfc2cbef67421251"
  license "MIT"
  head "https://github.com/krzysztofzablocki/Sourcery.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a03a5736679ebf2eb58a94819e4bd3905caf9161adcb51849b03264f1b05a4f4"
    sha256 cellar: :any_skip_relocation, big_sur:       "a16f7093eda6b3b048927e1eb2ee28082e22e8548720d18df4889675aad86f3e"
    sha256 cellar: :any_skip_relocation, catalina:      "40f8088f19d09e9079fe29a18ee923e0da7a2541a2afffef24890be0cea1e2e3"
  end

  depends_on xcode: "12.0"

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release"
    bin.install ".build/release/sourcery"
  end

  test do
    # Regular functionality requires a non-sandboxed environment, so we can only test version/help here.
    assert_match version.to_s, shell_output("#{bin}/sourcery --version").chomp
  end
end
