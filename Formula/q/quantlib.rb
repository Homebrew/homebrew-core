class Quantlib < Formula
  desc "Library for quantitative finance"
  homepage "https://www.quantlib.org/"
  url "https://github.com/lballabio/QuantLib/releases/download/v1.38/QuantLib-1.38.tar.gz"
  sha256 "7280ffd0b81901f8a9eb43bb4229e4de78384fc8bb2d9dcfb5aa8cf8b257b439"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e319f444e31940f0364e8398deb1f6077e60a2bda5ed1c90cf5333879e2be89e"
    sha256 cellar: :any,                 arm64_sonoma:  "51b6d9361b230a6595f65f1f72192c6500b437d06b55e026af32316402343432"
    sha256 cellar: :any,                 arm64_ventura: "fdaf876b826c57c317e98844d732a6626b9b59c165d1eb0d9bf60bc38d65e244"
    sha256 cellar: :any,                 sonoma:        "db571848eeb1677e0b289992082576bca793641d657f946d63b7e5d18135aff7"
    sha256 cellar: :any,                 ventura:       "c0603994c664e9b237cc9ab3597021173dd68ee18f6ede7b2e7a1cdb0d5766a0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d120612e1b0d505bd930e2fcbf450d14073e5847bfacfbf69e1415540399bddb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a1a1ee6ad6b4ca595a3ff9c632de0f5b3ff737fa3b7e8f2dc9abb9249230d88a"
  end

  head do
    url "https://github.com/lballabio/quantlib.git", branch: "master"

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
    end
  end

  test do
    system bin/"quantlib-config", "--prefix=#{prefix}", "--libs", "--cflags"
  end
end
