class RubyInstall < Formula
  desc "Install Ruby, JRuby, Rubinius, TruffleRuby, or mruby"
  homepage "https://github.com/postmodern/ruby-install#readme"
  url "https://github.com/postmodern/ruby-install/archive/v0.8.3.tar.gz"
  sha256 "e2f69949757d032d48ee5c028be020bdc8863c41d5648b53328903d2e16ab3b2"
  license "MIT"
  head "https://github.com/postmodern/ruby-install.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d19d4a89f08d447d522387e362b5e4627de5438e06396e2035fe735dc192d7de"
    sha256 cellar: :any_skip_relocation, big_sur:       "cd1ffd6780ab70d0701e812784ed7a7bb2276c6fc8f3303570fbf200a4f2ccde"
    sha256 cellar: :any_skip_relocation, catalina:      "cd1ffd6780ab70d0701e812784ed7a7bb2276c6fc8f3303570fbf200a4f2ccde"
    sha256 cellar: :any_skip_relocation, mojave:        "cd1ffd6780ab70d0701e812784ed7a7bb2276c6fc8f3303570fbf200a4f2ccde"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d19d4a89f08d447d522387e362b5e4627de5438e06396e2035fe735dc192d7de"
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
