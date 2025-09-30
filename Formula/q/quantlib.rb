class Quantlib < Formula
  desc "Library for quantitative finance"
  homepage "https://www.quantlib.org/"
  url "https://github.com/lballabio/QuantLib/releases/download/v1.39/QuantLib-1.39.tar.gz"
  sha256 "0126dac9fab908ca3df411ec8eb888ea1932c1044b1036d6df2f8159451fb700"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "78cde1e25586e8d635b7c699f4ed33d2d21f54de35ca1d87588873ec7289cf18"
    sha256 cellar: :any,                 arm64_sequoia: "d20a534cfeefb7cea299f6292240c2f9c438aca166fd0f45e1d5ceaa2c0afd44"
    sha256 cellar: :any,                 arm64_sonoma:  "9466a42e1ad25b969fcf07a4ea0972087c5b4bf4ed29240cb8e880270b27317c"
    sha256 cellar: :any,                 arm64_ventura: "f9b1575dcfbd307f0030c5b61ca5d9d26c9ae4caa9fcbaa0bb66f8dd3cb13d8a"
    sha256 cellar: :any,                 sonoma:        "2ecba83bf974eb035eb4614e57a22569f1c86ec56663935bde2b59663610ef76"
    sha256 cellar: :any,                 ventura:       "b700520b6e3d5e06369109767ba795e6dae937c5c43680a8c3f68687bbfe6b83"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "22f1eb26c69d559b72a750464ce7e3c3cedec7343341f8b31ef67b7347e4c4b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dd80e282e117da82507ef4070ace0bd46ff5428d919313017c37dc6f7162f0a0"
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
