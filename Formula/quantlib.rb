class Quantlib < Formula
  desc "Library for quantitative finance"
  homepage "https://www.quantlib.org/"
  url "https://github.com/lballabio/QuantLib/releases/download/QuantLib-v1.29/QuantLib-1.29.tar.gz"
  sha256 "b8127fb6fe5562dfabfcb7d62df4ba2f018de39d7fbe7df2b7a688578516b4b7"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "7a4a01f6f617700fb30594a4b417de4710bf68c072908a4546ded2309826cd14"
    sha256 cellar: :any,                 arm64_monterey: "d06fc70a2c4e1b4176cd14b5636fd738f5db424dd6ae1d51c0eacb4488284115"
    sha256 cellar: :any,                 arm64_big_sur:  "bef83614d72fe85ef332e8d49b05b7f9fe260d05ad3f5bee5144951ddeb6f2a2"
    sha256 cellar: :any,                 ventura:        "ee574115f4eb387ad7ecfb2031f2391daae38ee49971a095016da02a2906d265"
    sha256 cellar: :any,                 monterey:       "55ef4d3fedd132a9ac2c76c50f11ab16be6dda1363aed4930628cc9d46d9390c"
    sha256 cellar: :any,                 big_sur:        "9bc2785cc08496dfd1f0a0717392c6c3f9de3938abbbd85d18d117a7f918b12e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "367488e2678496a828cd038468c456794ee755047b8d6a196d4c6e99fa4586b0"
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
