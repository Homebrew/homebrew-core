class Sourcery < Formula
  desc "Meta-programming for Swift, stop writing boilerplate code"
  homepage "https://github.com/krzysztofzablocki/Sourcery"
  url "https://github.com/krzysztofzablocki/Sourcery/archive/1.9.0.tar.gz"
  sha256 "53cf70e490491a7b57897314b58f8af904b46fe648f26ceffbd98ed9295c3c0e"
  license "MIT"
  head "https://github.com/krzysztofzablocki/Sourcery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0f8ad70cf4d9dba61f8621513dc8db1c25bcee74c0a2da3a1013763e37add80c"
    sha256 cellar: :any_skip_relocation, monterey:       "9cc7c91be67833c608e94ec72d57531a86953318e97ec751bcaf86daf798c263"
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
