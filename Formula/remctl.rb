class Remctl < Formula
  desc "Client/server application for remote execution of tasks"
  homepage "https://www.eyrie.org/~eagle/software/remctl/"
  url "https://archives.eyrie.org/software/kerberos/remctl-3.18.tar.xz"
  sha256 "69980a0058c848f4d1117121cc9153f2daace5561d37bfdb061473f035fc35ef"
  license "MIT"

  livecheck do
    url "https://archives.eyrie.org/software/kerberos/"
    regex(/href=.*?remctl[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "b161331c32b5f808c45786646bf9d8d5244d04c0ef6ea946fcc63cd8dd0aa469"
    sha256 cellar: :any,                 arm64_big_sur:  "36c2ae6555c83a5af010c387a449c1e772e78a41ccb869e398ccaa10b4f08d06"
    sha256 cellar: :any,                 monterey:       "74f902bf328c3da38b39e8e72b9e5ff5d17d23d6feece805726bb04aff3ea9c4"
    sha256 cellar: :any,                 big_sur:        "94401316d2f15ab8e85032aaf27a339c109a93bf550cfc1809938e05d723b49a"
    sha256 cellar: :any,                 catalina:       "e9138bfed8e023dbb49f8007c51336f3b4a0174f5a265127701c727491648d09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a3e423da7f473592d54aa1d5af65df02443c0f0ad33c904eceeeb991303519ea"
  end

  depends_on "libevent"
  depends_on "pcre"

  uses_from_macos "krb5"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-pcre=#{HOMEBREW_PREFIX}"
    system "make", "install"
  end

  test do
    system "#{bin}/remctl", "-v"
  end
end
