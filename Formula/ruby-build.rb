class RubyBuild < Formula
  desc "Install various Ruby versions and implementations"
  homepage "https://github.com/rbenv/ruby-build"
  url "https://github.com/rbenv/ruby-build/archive/v20181225.tar.gz"
  sha256 "5ace4787ace47384dc419b20f5eb5a59f1174e00bfabcfed74a175033cd0b18a"
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
