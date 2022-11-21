class Rcm < Formula
  desc "RC file (dotfile) management"
  homepage "https://thoughtbot.github.io/rcm/rcm.7.html"
  url "https://thoughtbot.github.io/rcm/dist/rcm-1.3.5.tar.gz"
  sha256 "24741e7f26f16a049324baa86af700443c4281e2cde099729d74c4d4b29ebe2d"
  license "BSD-3-Clause"

  # The first-party website doesn't appear to provide links to archive files, so
  # we check the Git repository tags instead.
  livecheck do
    url "https://github.com/thoughtbot/rcm.git"
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6b4023f9e2b482466d619cd2597001e167da9abd8d8a4306f79d7de32494f08a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6b4023f9e2b482466d619cd2597001e167da9abd8d8a4306f79d7de32494f08a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6b4023f9e2b482466d619cd2597001e167da9abd8d8a4306f79d7de32494f08a"
    sha256 cellar: :any_skip_relocation, ventura:        "6b4023f9e2b482466d619cd2597001e167da9abd8d8a4306f79d7de32494f08a"
    sha256 cellar: :any_skip_relocation, monterey:       "6b4023f9e2b482466d619cd2597001e167da9abd8d8a4306f79d7de32494f08a"
    sha256 cellar: :any_skip_relocation, big_sur:        "6b4023f9e2b482466d619cd2597001e167da9abd8d8a4306f79d7de32494f08a"
    sha256 cellar: :any_skip_relocation, catalina:       "6b4023f9e2b482466d619cd2597001e167da9abd8d8a4306f79d7de32494f08a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0ee4e4a747f2ae336116500cecfe49d507ae96ae2aa80bedc1a8574b52556ead"
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
