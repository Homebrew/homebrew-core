class Singular < Formula
  desc "Computer algebra system for polynomial computations"
  homepage "https://www.singular.uni-kl.de/"
  url "https://www.singular.uni-kl.de/ftp/pub/Math/Singular/SOURCES/4-4-1/singular-4.4.1p5.tar.gz"
  version "4.4.1p5"
  sha256 "bce5a40bd10b6e9fe991de97e6284f62cdb566c8aef4b2836b4d1307eb7d9edf"
  license "GPL-2.0-or-later"
  revision 3

  livecheck do
    url "https://www.singular.uni-kl.de/ftp/pub/Math/Singular/SOURCES/"
    regex(%r{href=["']?v?(\d+(?:[.-]\d+)+)/?["' >]}i)
    strategy :page_match do |page, regex|
      # Match versions from directories
      versions = page.scan(regex)
                     .flatten
                     .uniq
                     .map { |v| Version.new(v.tr("-", ".")) }
                     .reject { |v| v.patch >= 90 }
                     .sort
      next versions if versions.blank?

      # Assume the last-sorted version is newest
      newest_version = versions.last

      # Fetch the page for the newest version directory
      dir_page = Homebrew::Livecheck::Strategy.page_content(
        URI.join(@url, "#{newest_version.to_s.tr(".", "-")}/").to_s,
      )
      next versions if dir_page[:content].blank?

      # Identify versions from files in the version directory
      dir_versions = dir_page[:content].scan(/href=.*?singular[._-]v?(\d+(?:\.\d+)+(?:p\d+)?)\.t/i).flatten

      dir_versions || versions
    end
  end

  bottle do
    rebuild 1
    sha256 arm64_golden_gate: "cf2dfcca855c1dbb38a55f6bf3ed3fbcc16f27c0f0ed5812350178f9bb206d4c"
    sha256 arm64_tahoe:       "c2247c8d99c4b9d966f26968cbd1713c962dc008a6b97b6aa7fb80b6db25d62d"
    sha256 arm64_sequoia:     "5e03ab7db05efb09e23c15eb24ffa75d9b950a34f67cfa160758027927783ec1"
    sha256 arm64_linux:       "9d2473e8d2138d34a7c7c48be2c45215691f644d2467daaa01747b9dde8e2528"
    sha256 x86_64_linux:      "c3b0126fd2aa5b0ce2e51279a1b10e703410572b23d2c3253e7f45de9cb22c8b"
  end

  head do
    url "https://github.com/Singular/Singular.git", branch: "spielwiese"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "flint"
  depends_on "gmp"
  depends_on "mpfr"
  depends_on "ntl"
  depends_on "python@3.15"
  depends_on "readline"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-silent-rules",
                          "--with-python=#{python3}",
                          "CXXFLAGS=-std=c++11",
                          *std_configure_args
    system "make", "install"
  end

  test do
    testinput = <<~EOS
      ring r = 0,(x,y,z),dp;
      poly p = x;
      poly q = y;
      poly qq = z;
      p*q*qq;
    EOS
    assert_match "xyz", pipe_output("#{bin}/Singular", testinput, 0)
  end
end
