class RubyInstall < Formula
  desc "Install Ruby, JRuby, Rubinius, TruffleRuby, or mruby"
  homepage "https://github.com/postmodern/ruby-install#readme"
  url "https://github.com/postmodern/ruby-install/archive/v0.8.3.tar.gz"
  sha256 "e2f69949757d032d48ee5c028be020bdc8863c41d5648b53328903d2e16ab3b2"
  license "MIT"
  head "https://github.com/postmodern/ruby-install.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "dc8ccd83e5f95f77186431f37297226dfc15042ab835da617c03dd052e73e6b7"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"

    # Ensure uniform bottles across prefixes
    inreplace man1/"ruby-install.1", "/usr/local", "$HOMEBREW_PREFIX"
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
