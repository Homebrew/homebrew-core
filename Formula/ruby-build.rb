class RubyBuild < Formula
  desc "Install various Ruby versions and implementations"
  homepage "https://github.com/rbenv/ruby-build"
  url "https://github.com/rbenv/ruby-build/archive/v20181019.tar.gz"
  sha256 "5ac5838e81ac06478aa23de79aefc4196f7d1ba8aa1a3cc03bc6e81708463a9e"
  head "https://github.com/rbenv/ruby-build.git"

  bottle :unneeded

  depends_on "autoconf"
  depends_on "openssl"
  depends_on "pkg-config"

  def install
    ENV["PREFIX"] = prefix
    system "./install.sh"
  end

  test do
    assert_match "2.0.0", shell_output("#{bin}/ruby-build --definitions")
  end
end
