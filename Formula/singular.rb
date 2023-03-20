class Singular < Formula
  desc "Computer algebra system for polynomial computations"
  homepage "https://www.singular.uni-kl.de/"
  url "https://www.singular.uni-kl.de/ftp/pub/Math/Singular/SOURCES/4-3-2/singular-4.3.2.tar.gz"
  sha256 "3fd565d1bd4265fa8ba7cc189137a36d9daf9939b5bb411466c2028d9191f6db"
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
        URI.join(@url, "#{newest_version.to_s.tr(".", "-")}/"),
      )
      next versions if dir_page[:content].blank?

      # Identify versions from files in the version directory
      dir_versions = dir_page[:content].scan(/href=.*?singular[._-]v?(\d+(?:\.\d+)+(?:p\d+)?)\.t/i).flatten

      dir_versions || versions
    end
  end

  bottle do
    sha256 arm64_ventura:  "a09bbe11e96ea0ede75ccce6e27ee298eb93084e3bb65e4775cfca76e03a923c"
    sha256 arm64_monterey: "a4979fab796c8db15f9a9387560c3ced01ed6fa892796fb1795bf07fcfb2ea88"
    sha256 arm64_big_sur:  "adb7c53e6492ae1fb270dbb63c09df102d295ffd651a989bf1ec763fdbbd896f"
    sha256 ventura:        "105352f402f24a014a5ff9817154b803cc2f222e02e60277fa2f182ce5bd4a38"
    sha256 monterey:       "b3ac765755f9181cf2e75f40905d17c8229de0834d16447074ccf278c30a60c5"
    sha256 big_sur:        "eb5ab8271b4810247dd58d44951b6611610f7d805973541a72869298e9a8a99f"
    sha256 x86_64_linux:   "7d8a9346480d55af00fb1bf2290cefc06643b5d11e187970dd5ecc59ab604966"
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
