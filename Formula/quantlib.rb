class Quantlib < Formula
  desc "Library for quantitative finance"
  homepage "https://www.quantlib.org/"
  url "https://github.com/lballabio/QuantLib/releases/download/QuantLib-v1.30/QuantLib-1.30.tar.gz"
  sha256 "10159054b68cb9a39480d9000b87851f49e6f42474a4cb9367e934bece2363f3"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "60330da4ac214dc8fc9ab0dc468d3cdf46d2377a034afe5ab71ec1a875086f59"
    sha256 cellar: :any,                 arm64_monterey: "b8cea0e9613e071c11d2b6290b626e810b92bad01630affd82ca765e6211359b"
    sha256 cellar: :any,                 arm64_big_sur:  "bb2c90789265a0b8c552a7e64e03f222e888db9d89ac38559be2ed8bc345e25c"
    sha256 cellar: :any,                 ventura:        "414262973178e1c524938b622e0dfc738a0b8690af2c40dcef7c87672a0d4b13"
    sha256 cellar: :any,                 monterey:       "bc6962698982bfe4317c39c59600d811479fa182b8571d25a2e726b09db71ac8"
    sha256 cellar: :any,                 big_sur:        "d94d99089afa9d278b5acfd29b66517cb9539d970ce12394ae2019041dd7237a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "568fe097ce2afc9d80ca99ce63ba433eb628f4a9bf69cbc41cfd90f0ca561b95"
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
      prefix.install_metafiles
    end
  end

  test do
    system bin/"quantlib-config", "--prefix=#{prefix}", "--libs", "--cflags"
  end
end
