class Singular < Formula
  desc "Computer algebra system for polynomial computations"
  homepage "https://www.singular.uni-kl.de/"
  url "https://www.singular.uni-kl.de/ftp/pub/Math/Singular/SOURCES/4-3-2/singular-4.3.2p2.tar.gz"
  version "4.3.2p2"
  sha256 "660ae93ace79db4209203770d93baf16b5b741dc26b6bae06c9b2c98ad188df1"
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
    sha256 arm64_ventura:  "cd3ca39feba69347558a0e08ed5025b13f8fc61bd7c4ae8b2099e555db63a3b0"
    sha256 arm64_monterey: "e15effe8146eed0ffa64e4a963308eb9a3729331a5df792c5fcee28f28bee4f6"
    sha256 arm64_big_sur:  "2c48ef40c8329e92af3501db0cdb60c5026d379f885c46d270a89361f40c73b2"
    sha256 ventura:        "3cdb409f43fed4a8096fc625d91b3943a7ee531ed6808b73d1baa627187c8079"
    sha256 monterey:       "67a42a53f17d3e35af8530f7f4616ffd7a44629e51776db583a54463a81f72be"
    sha256 big_sur:        "b3c72f44be646fd295d1edc466c52a2f8f3800eca7cbe7d1286b6b1c5c8cab41"
    sha256 x86_64_linux:   "f20281d5b6fd85c880df5b21953a822307945e856c4f34e453d7a39d82a327c0"
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
