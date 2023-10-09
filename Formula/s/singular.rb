class Singular < Formula
  desc "Computer algebra system for polynomial computations"
  homepage "https://www.singular.uni-kl.de/"
  url "https://www.singular.uni-kl.de/ftp/pub/Math/Singular/SOURCES/4-3-2/singular-4.3.2p8.tar.gz"
  version "4.3.2p8"
  sha256 "8f157d2c582614482285838345ed7a3629ad6dd0bfbbc16eed7cbee0ff69d072"
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
    sha256 arm64_sonoma:   "f5927d587c8e661fbd402867096ec7c435f59b7ccc00ae6f90d157543378230a"
    sha256 arm64_ventura:  "16bb231b8282bb11d92c09a64f298fec8dfefa09610371a40e894fb23bdd5484"
    sha256 arm64_monterey: "52ce046849a6ee1a5d83abc65cc3c5af5021385cff50125bb657b75294a2fa61"
    sha256 sonoma:         "869d2cf6961d6bff7bcc38e13d6567877034690bd9b20d21883a4b9aea6fdc08"
    sha256 ventura:        "1766fabc717d6b25f3a594be753e7a7747d26c85aa16e1d57ad4b7cad20c4f3b"
    sha256 monterey:       "713ffbc8c8ef0ad9e187dbf54114f78ab8c4e25f08a4b688c651e7a236b8f182"
    sha256 x86_64_linux:   "d5b11cc8b14ee82535e017103b130244df3eb241385b5dd5f2b23427e4ba6a68"
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
