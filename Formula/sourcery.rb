class Sourcery < Formula
  desc "Meta-programming for Swift, stop writing boilerplate code"
  homepage "https://github.com/krzysztofzablocki/Sourcery"
  url "https://github.com/krzysztofzablocki/Sourcery/archive/1.7.0.tar.gz"
  sha256 "965f1302efe50ac5601130773e53a208e2820a27280658cf874f5484d5d94d6e"
  license "MIT"
  head "https://github.com/krzysztofzablocki/Sourcery.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_monterey: "610c06a6f7861b6a215a390c1e069f739d2990164a84d15aac16afdeeff9c4ac"
    sha256 cellar: :any, arm64_big_sur:  "2ff7c9ee3d1d140289e00df614a69f470b61be3e87d9b2e0b69ebe8cedb7f3cf"
    sha256 cellar: :any, monterey:       "e4ac024ab746343d0ae2ffff5b1ecdd0a54ccb0666dd5324f9d00b44b6f2fcec"
    sha256 cellar: :any, big_sur:        "d880261ffceb5d27a1e00c9bb370465341c4f6ab096ef4bb3d64a804d780cd6f"
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
