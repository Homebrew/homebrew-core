class Sourcery < Formula
  desc "Meta-programming for Swift, stop writing boilerplate code"
  homepage "https://github.com/krzysztofzablocki/Sourcery"
  url "https://github.com/krzysztofzablocki/Sourcery/archive/1.8.1.tar.gz"
  sha256 "a60b920b9dc4d3b7dc38c9d3593391c399ae6c5966734bb6d6991b73d0959898"
  license "MIT"
  head "https://github.com/krzysztofzablocki/Sourcery.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_monterey: "de4d7568837212aa28b1ba27816eb19700a4281cd84933450eaafabe1ec366fc"
    sha256 cellar: :any, arm64_big_sur:  "da4bb2f3940a6e1da7e721f3e605a8300500ed36b2dbba4bcc7c482adb7ad5ce"
    sha256 cellar: :any, monterey:       "62a691af20efe05bca51ad373031cd083d621c9e5dad0f97c40dca89e282192d"
    sha256 cellar: :any, big_sur:        "c33358f787a7ef84d96815b9e7b06fdfea204490cab7e27f6dc00404b3f2c88d"
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
