class RubyInstall < Formula
  desc "Install Ruby, JRuby, Rubinius, TruffleRuby, or mruby"
  homepage "https://github.com/postmodern/ruby-install"
  url "https://github.com/postmodern/ruby-install/releases/download/v0.10.0/ruby-install-0.10.0.tar.gz"
  sha256 "8aee2224b33d661a7db777b094adb10390b8962ff9b5a76765dd4f3e9ef16176"
  license "MIT"
  head "https://github.com/postmodern/ruby-install.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d51c12cf1121a924eb32650530cc19482d5c7396d622aaad7643d6b8d891b97d"
  end

  depends_on "xz"

  def install
    system "make", "install", "PREFIX=#{prefix}"

    # Ensure uniform bottles across prefixes
    inreplace [
      pkgshare/"ruby-install.sh",
      pkgshare/"truffleruby/functions.sh",
      pkgshare/"truffleruby-graalvm/functions.sh",
    ], "/usr/local", HOMEBREW_PREFIX
  end

  test do
    system bin/"ruby-install"
  end
end
