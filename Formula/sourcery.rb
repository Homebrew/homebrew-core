class Sourcery < Formula
  desc "Meta-programming for Swift, stop writing boilerplate code"
  homepage "https://github.com/krzysztofzablocki/Sourcery"
  url "https://github.com/krzysztofzablocki/Sourcery/archive/1.9.2.tar.gz"
  sha256 "7373b6d6b6bfb6959b63ac30d70334ec09aba79c27b5e1c1a69871ccf573f335"
  license "MIT"
  head "https://github.com/krzysztofzablocki/Sourcery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "195962adcd1b5086e911fc1b2f0fb2372b51c8241bed3fcc0cddfc1ae3e5f8ff"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6a591570edf1aec3ba83d4666a5164c95f4d4d373290aa8743226eec18d264b5"
    sha256 cellar: :any_skip_relocation, ventura:        "6fc6d074e9f4653c1a86ac81130b2cff24743ea65091397bb99fd0662f7659f6"
    sha256 cellar: :any_skip_relocation, monterey:       "aa587c053fe78ba11db87a38e9476f1a1a44a56fb24149d43e127b0776c8ec1e"
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
