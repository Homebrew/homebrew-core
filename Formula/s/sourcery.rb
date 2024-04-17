class Sourcery < Formula
  desc "Meta-programming for Swift, stop writing boilerplate code"
  homepage "https://github.com/krzysztofzablocki/Sourcery"
  url "https://github.com/krzysztofzablocki/Sourcery/archive/refs/tags/2.2.3.tar.gz"
  sha256 "feac21b0a9b6b7dd3c277c16a85e17bf3b713631291f0a93a36ee4a5a87fba70"
  license "MIT"
  version_scheme 1
  head "https://github.com/krzysztofzablocki/Sourcery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "64e3628dc62492231c608c05f851ca546d13d686e607f3c41a4ce2797263c1b4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2fc3a3525d6f9c0f4a1d77b99aa0ac2f44ac2c44df07edb61f65c1c90cb7af1b"
    sha256 cellar: :any_skip_relocation, sonoma:        "85be7c53722bf07614def54f6c24ec3053b1a7048d96c6434e6f6b5f4d7de9d3"
    sha256 cellar: :any_skip_relocation, ventura:       "6a6e998920bf546eba6661f8821558f37dc2140da7bb66f2a73444c3e4a5f792"
    sha256                               x86_64_linux:  "705041ff2c2c1cf2bdc8356c575060d470235ffc2be8f1382517cf776b2eae2a"
  end

  depends_on xcode: "14.3"

  uses_from_macos "ruby" => :build
  uses_from_macos "sqlite"
  uses_from_macos "swift"

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
