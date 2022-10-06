class Sourcery < Formula
  desc "Meta-programming for Swift, stop writing boilerplate code"
  homepage "https://github.com/krzysztofzablocki/Sourcery"
  url "https://github.com/krzysztofzablocki/Sourcery/archive/1.9.0.tar.gz"
  sha256 "53cf70e490491a7b57897314b58f8af904b46fe648f26ceffbd98ed9295c3c0e"
  license "MIT"
  head "https://github.com/krzysztofzablocki/Sourcery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0b1bf2c761a91011e49d8f4f931114d94b41ebb452c96868c51148d7669196dc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8fae717d49cc6af56057ef970eab7b40016200493467519f63b4f05437dfeb36"
    sha256 cellar: :any_skip_relocation, monterey:       "6725c044f5259aadcca412185d8bcc6e2d6bb4cfb3c3f04978a14bf32adbfd28"
    sha256 cellar: :any_skip_relocation, big_sur:        "27f0bb3aa77c04122c28cd087e565f5b9189945b80a1cf6b87644fa0276e39f4"
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
