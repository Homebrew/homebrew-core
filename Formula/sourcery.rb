class Sourcery < Formula
  desc "Meta-programming for Swift, stop writing boilerplate code"
  homepage "https://github.com/krzysztofzablocki/Sourcery"
  url "https://github.com/krzysztofzablocki/Sourcery/archive/1.5.0.tar.gz"
  sha256 "df21295ae7cd309e7c1d6687aeee6e12a2677af2faf0da39bfd23d188ef12b08"
  license "MIT"
  head "https://github.com/krzysztofzablocki/Sourcery.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "04d7339341fb2d09c58d142c250acffc04ae1ad5a27e40f0d8bcf1e722ba7720"
    sha256 cellar: :any, big_sur:       "fef184ef3c00e33ad0e5167cb563e674f10731ae23cd4849d7ef7dcca941963b"
    sha256 cellar: :any, catalina:      "d5904bbdafedb7a8922b663f4716be4a7be923b16851595531835ab17a3bd1a8"
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
