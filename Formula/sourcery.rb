class Sourcery < Formula
  desc "Meta-programming for Swift, stop writing boilerplate code"
  homepage "https://github.com/krzysztofzablocki/Sourcery"
  url "https://github.com/krzysztofzablocki/Sourcery/archive/2.0.0.tar.gz"
  sha256 "947d4d2758528ccca77de0f4b528365e1ce77e917a4af810afcc3a0328caa473"
  license "MIT"
  head "https://github.com/krzysztofzablocki/Sourcery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "37f85dd2fc0091ba35abf1bc059ac2ab9eb7490955b327445f52d5c92a26fd44"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5bd5a098011084a2eb0a967382a93997975535195badd3ad5807e3cd19fdcf6e"
    sha256 cellar: :any_skip_relocation, ventura:        "3be6812ef327e5e0d9ba0b52c6809e89ec74a4effdcefc4968f7fbc369efcbe2"
    sha256 cellar: :any_skip_relocation, monterey:       "26816c3345810c1b3e154dbdb6b273ea59ba87394dc9773092beee1d223ff0b6"
  end

  depends_on :macos # Linux support is still a WIP: https://github.com/krzysztofzablocki/Sourcery/issues/306
  depends_on xcode: "13.3"

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
