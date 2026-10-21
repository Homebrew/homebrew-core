class Quantlib < Formula
  desc "Library for quantitative finance"
  homepage "https://www.quantlib.org/"
  url "https://github.com/lballabio/QuantLib/releases/download/v1.44/QuantLib-1.44.tar.gz"
  sha256 "34d7787a367404447f84be6942b19fd091f1e8e45a380d3f153e6cd8c4bb8ad8"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "2885f3cd85b501f49ec8fd7603ea9991e8606764b6947c19e948445c18313172"
    sha256 cellar: :any, arm64_tahoe:       "42ee71a9b4188d1106f2395b96042fdab6c254ae1bc914d59cc00b6bb089cb8b"
    sha256 cellar: :any, arm64_sequoia:     "82e15fc4efd544757aa4a054a8ff8e41eb61871d83b3240e4a14980aa73709da"
    sha256 cellar: :any, arm64_linux:       "2d700f7ebcc97df96eb3ff9733a1d019cd2298612bc95b9bc030c35d35991ab2"
    sha256 cellar: :any, x86_64_linux:      "30a0d7acb033600e2372d048fc000bac657aab67c9edf33ca638442b58ffff32"
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
