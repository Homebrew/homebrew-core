class Singular < Formula
  desc "Computer algebra system for polynomial computations"
  homepage "https://www.singular.uni-kl.de/"
  url "https://www.singular.uni-kl.de/ftp/pub/Math/Singular/SOURCES/4-3-2/singular-4.3.2p7.tar.gz"
  version "4.3.2p7"
  sha256 "aad23c30066b7fbc011138a98d60532565d76a847eec6bf2938410d93b272ca3"
  license "GPL-2.0-or-later"

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
    sha256 arm64_ventura:  "e4bca358fc37252fdab16cd47f4533a83f71ba7f2f1db6792157964b66a48d99"
    sha256 arm64_monterey: "217f2210bf75469d9e142ed6caaf7e2a006364a62edb615e9836e2a0c3f15d4c"
    sha256 arm64_big_sur:  "472b6015c52c58d15e46d0771c8d86e222d523ec6bd3d4dbe46b1dc083210cd5"
    sha256 ventura:        "30089d5d89ab41ee9131e55b2f70e8332dbdb3767bb2fc8d75e9574549addd13"
    sha256 monterey:       "5b6c2b618d3c6888a96c387d54359a98d7f9803689022b96d4e26b916de3892e"
    sha256 big_sur:        "9a3920401516777906706342923e2da4e2086a5e18652a042c5b2231253ae280"
    sha256 x86_64_linux:   "41b478f1798726bf25a2bc98c2311c4c7fab5e0a743f7c00f04c5e9096547720"
  end

  head do
    url "https://github.com/Singular/Singular.git", branch: "spielwiese"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "gmp"
  depends_on "mpfr"
  depends_on "ntl"
  depends_on "python@3.11"

  on_macos do
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  def install
    # Run autogen on macOS so that -flat_namespace flag is not used.
    system "./autogen.sh" if build.head? || OS.mac?
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-python=#{which("python3.11")}",
                          "CXXFLAGS=-std=c++11"
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
