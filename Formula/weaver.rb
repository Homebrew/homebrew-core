class Weaver < Formula
  desc "Command-line tool for Weaver"
  homepage "https://github.com/scribd/Weaver"
  url "https://github.com/scribd/Weaver/archive/1.0.7.tar.gz"
  sha256 "600a49ea7dbe58f57bf40afb7be7a42fb382ce41d807549e427b23e8504d5e02"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "a0b1284a91a4647fa7b3c980fc237b0677e959c821d62ca31a5b3ea8a63abf40" => :catalina
    sha256 "3db8730a06cb3ddd12a35097239afd85ea365c3e291a73422f37f23955230007" => :mojave
  end

  depends_on xcode: ["11.2", :build]

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    # Weaver uses Sourcekitten and thus, has the same sandbox issues.
    # Rewrite test after sandbox issues investigated.
    # https://github.com/Homebrew/homebrew/pull/50211
    system "#{bin}/weaver", "version"
  end
end
