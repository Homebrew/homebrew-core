class Quantlib < Formula
  desc "Library for quantitative finance"
  homepage "https://www.quantlib.org/"
  url "https://github.com/lballabio/QuantLib/releases/download/v1.43/QuantLib-1.43.tar.gz"
  sha256 "b41206ccc4ba39b5e86bdc940d51138222b352f79d2c6fc68649f9c9bbe58701"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "ea1cde8f958e5a5a7e821f57b1bbde543ae67f82bc722d190f90c76c0dfba688"
    sha256 cellar: :any, arm64_sequoia: "0d27c612bfc6c9d7c785618c2c8e39f08868cfadf5960ef1dba06c24003f4bb7"
    sha256 cellar: :any, arm64_sonoma:  "3bb2c3afc1adc316caa109344733ecca5e0a60989293ab4ceb7777439a6a1e27"
    sha256 cellar: :any, sonoma:        "32e6e2f47d78019b61028bdc5b5a2076b704fdf74f30394bb6ac2a3f5fbfb869"
    sha256 cellar: :any, arm64_linux:   "8878588f1c55bb4e9917f50b88d91b13ee39f9d489b047da3069bd731fe63959"
    sha256 cellar: :any, x86_64_linux:  "4b962f2ec6fe7aa0ff1ec23b0827885012997932e4665acfa07ec67e91400921"
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
