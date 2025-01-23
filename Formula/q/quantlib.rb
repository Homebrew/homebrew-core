class Quantlib < Formula
  desc "Library for quantitative finance"
  homepage "https://www.quantlib.org/"
  url "https://github.com/lballabio/QuantLib/releases/download/v1.37/QuantLib-1.37.tar.gz"
  sha256 "b284e54ef2133c9eccccc23e210ae5b41b2f37c797b3d7257492a391e436ad24"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a260eed77410c1810daf98f6bd3a225bec5345e8fd7eef0387674062e7f82a24"
    sha256 cellar: :any,                 arm64_sonoma:  "e16bb557632a3c717cbcfe313777660e5bcd8a947627b53b91da0e9c392dab47"
    sha256 cellar: :any,                 arm64_ventura: "930b58c0d30608c8a0d9477e1b3c767046460a58697995d8315eba57e1fa15e5"
    sha256 cellar: :any,                 sonoma:        "8ca81c3ce45c996b7ff9f72cb620c61843581019bcf68d3a25cf8ae52ed77ec3"
    sha256 cellar: :any,                 ventura:       "f06734001cb1c4ae23aa159af0d1ab9495c7e038dc0250345290a77d1917c091"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "04c22fea4ff52f74fe932242915d7122cb4eaf66fc31faae5461df650ebda564"
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
