class RubyBuild < Formula
  desc "Install various Ruby versions and implementations"
  homepage "https://github.com/rbenv/ruby-build"
  url "https://github.com/rbenv/ruby-build/archive/v20191002.tar.gz"
  sha256 "0d343cfa5db46e7777160d00b4ed29d94434c39b5a4582d3e580206ba2c8f053"
  head "https://github.com/rbenv/ruby-build.git"

  bottle :unneeded

  depends_on "autoconf"
  depends_on "openssl@1.1"
  depends_on "pkg-config"
  depends_on "readline"

  def install
    ENV["PREFIX"] = prefix
    system "./install.sh"
  end

  test do
    assert_match "2.0.0", shell_output("#{bin}/ruby-build --definitions")
  end
end
