class Quantlib < Formula
  desc "Library for quantitative finance"
  homepage "https://www.quantlib.org/"
  url "https://github.com/lballabio/QuantLib/releases/download/v1.40/QuantLib-1.40.tar.gz"
  sha256 "5d6b971b998b8b47e5694dfc4851e9c8809624ff24c620579efc7fedef9dc149"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "58937ba7f8806db68889903a328ddc94edf78bf92bbc8ee09fb71272649bd1db"
    sha256 cellar: :any,                 arm64_sequoia: "77f85d593d7c0dff0bf47800fed21cb86c2338049af672cc19cdaa0325a5e5bf"
    sha256 cellar: :any,                 arm64_sonoma:  "06b5e6ee4920b501f7e2676167d4622fed88bb18629d68b02e61beb53bbb5f13"
    sha256 cellar: :any,                 sonoma:        "e01238d588812433834915f2f8589297f19a033f45b1fe104654741ab19c1c67"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "499049928740908c868de1fdc617702d74cf7045d776ae02612c840eb37233d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6b1dbe754cf7b0d255b9161577ee51acea10a19a60178299bfebad0f24755099"
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
