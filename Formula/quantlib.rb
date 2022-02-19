class Quantlib < Formula
  desc "Library for quantitative finance"
  homepage "https://www.quantlib.org/"
  url "https://github.com/lballabio/QuantLib/releases/download/QuantLib-v1.25/QuantLib-1.25.tar.gz"
  sha256 "0fbe8f621b837b6712d74102892a97a0f09e24a55a34dfc74f1e743a45d73d1d"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "bbead0dc54dcc9e65fcb9b07df7b99de5a283b724b49af3a10f1915a54837cc7"
    sha256 cellar: :any,                 arm64_big_sur:  "4153ec68ee7db16e603d92c870983f6733e6c90353d2ab9f4d473417e1351406"
    sha256 cellar: :any,                 monterey:       "e6120451ec188afc0fd50a71de125ae2e6b0858fd66bca2b39f3a6ef91090fee"
    sha256 cellar: :any,                 big_sur:        "179ac883ba7f01c695bb5e77efbf3eca13a63bc7e40a827d81747382d00d092b"
    sha256 cellar: :any,                 catalina:       "d8d24f3b576291bf5ceba3553897e5e5e71be85609c98cab5d5b31fa0827f622"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aadf3b7fbd1be69b3a92fc67095e8570a596fc8f381fa2e611dbaeea82fb3583"
  end

  head do
    url "https://github.com/lballabio/quantlib.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "boost"

  def install
    ENV.cxx11
    (buildpath/"QuantLib").install buildpath.children if build.stable?
    cd "QuantLib" do
      system "./autogen.sh" if build.head?
      system "./configure", "--disable-dependency-tracking",
                            "--prefix=#{prefix}",
                            "--with-lispdir=#{elisp}",
                            "--enable-intraday"

      system "make", "install"
      prefix.install_metafiles
    end
  end

  test do
    system bin/"quantlib-config", "--prefix=#{prefix}", "--libs", "--cflags"
  end
end
