class Recode < Formula
  desc "Convert character set (charsets)"
  homepage "https://github.com/rrthomas/recode"
  url "https://github.com/rrthomas/recode/releases/download/v3.7.10/recode-3.7.10.tar.gz"
  sha256 "4a4b00a6080f8ef77956a18040454785d35b66ab7d8105ffd971798aa4a8f186"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "f90377777dde4ec023ca2fc58eb27f329476a3374eae278e68c4d9055f171ed2"
    sha256 cellar: :any,                 arm64_big_sur:  "9de0576464a54b86cc1dbef266840a0191c9ff6f49f9f2d2f241d7e718fdc650"
    sha256 cellar: :any,                 monterey:       "0b81e5415b4b9a2192a3ca53fcb7c92ccdd5ad51643b1f50e4104ed562d8f27d"
    sha256 cellar: :any,                 big_sur:        "9976f338086c7a83eb7b03f08545bb0107604c91bd4d645a8e5952824dca9d38"
    sha256 cellar: :any,                 catalina:       "72f6932b70d83f40ea622fce34345fdc074a00389ca7be144c52159afd488fc5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c07c0d30ff0c8d420a552f8288241eee5ac3f50d0348ddc633a171e8712c22d0"
  end

  depends_on "libtool" => :build
  depends_on "python@3.10" => :build
  depends_on "gettext"

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/recode --version")
  end
end
