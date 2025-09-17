class RubyBuild < Formula
  desc "Install various Ruby versions and implementations"
  homepage "https://rbenv.org/man/ruby-build.1"
  url "https://github.com/rbenv/ruby-build/archive/refs/tags/v20250916.1.tar.gz"
  sha256 "3e2c33a21a21cda5b4f8725850f9f142a4af0a4062b8b40d1e3c9fae7b50f3b2"
  license "MIT"
  head "https://github.com/rbenv/ruby-build.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8a76ebc39a871eceb40bef84098c1dd4bce352e8a671cfbd28de3c951c7318f2"
  end

  depends_on "autoconf"
  depends_on "libyaml"
  depends_on "openssl@3"
  depends_on "pkgconf"
  depends_on "readline"

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    assert_match "2.0.0", shell_output("#{bin}/ruby-build --definitions")
  end
end
