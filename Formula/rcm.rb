class Rcm < Formula
  desc "RC file (dotfile) management"
  homepage "https://thoughtbot.github.io/rcm/rcm.7.html"
  url "https://thoughtbot.github.io/rcm/dist/rcm-1.3.6.tar.gz"
  sha256 "f4fdfbc451d1fb5764531290a202a0a871f6b81ba3c01a6b76c49435c85080a5"
  license "BSD-3-Clause"

  # The first-party website doesn't appear to provide links to archive files, so
  # we check the Git repository tags instead.
  livecheck do
    url "https://github.com/thoughtbot/rcm.git"
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "71cd9064bce03baa3db0f2cf099d4e103d910508ef14306a32b0f75877a5c2b0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "71cd9064bce03baa3db0f2cf099d4e103d910508ef14306a32b0f75877a5c2b0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "71cd9064bce03baa3db0f2cf099d4e103d910508ef14306a32b0f75877a5c2b0"
    sha256 cellar: :any_skip_relocation, ventura:        "71cd9064bce03baa3db0f2cf099d4e103d910508ef14306a32b0f75877a5c2b0"
    sha256 cellar: :any_skip_relocation, monterey:       "71cd9064bce03baa3db0f2cf099d4e103d910508ef14306a32b0f75877a5c2b0"
    sha256 cellar: :any_skip_relocation, big_sur:        "71cd9064bce03baa3db0f2cf099d4e103d910508ef14306a32b0f75877a5c2b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "005d4a522f959bc42ac42573cce793a33a6cf5742f34405efd1c7025370f347e"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/".dotfiles").mkdir
    (testpath/".gitconfig").write <<~EOS
      [user]
      	name = Test User
      	email = test@test.com
    EOS
    assert_match(/(Moving|Linking)\.\.\./x, shell_output("#{bin}/mkrc -v ~/.gitconfig"))
  end
end
