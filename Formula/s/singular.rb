class Singular < Formula
  desc "Computer algebra system for polynomial computations"
  homepage "https://www.singular.uni-kl.de/"
  url "https://www.singular.uni-kl.de/ftp/pub/Math/Singular/SOURCES/4-4-1/singular-4.4.1.tar.gz"
  sha256 "6a4fbaaed05b89c35bff3b1c5e124344a088097f81affe129c9ae619b282b49b"
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
    sha256 arm64_sequoia: "70b291bd6c98c86973cb8db92391d51b37725dbce650ce9270a5da2bf4d40da7"
    sha256 arm64_sonoma:  "1d3125671e760cd654015351a9e8e9399a928126fd3303f547e495c61bfb865e"
    sha256 arm64_ventura: "89a18b75b03f523ebda9e2e0df5f566aed4ee94e8feb8d79fead7aa60a7f311f"
    sha256 sonoma:        "d6aa383f1e6c98f1226c70d5ce193d43f7ae41537ed368604d9b8210e44d974b"
    sha256 ventura:       "9fd6df9be35e01b7e4e1d003d6845c917b980db7d7223ec05e18df5efe6b3660"
    sha256 arm64_linux:   "ab0f3dad935025696cdc3207449769b84d9e0523c9ed79c7e00c9ff9fee771fa"
    sha256 x86_64_linux:  "cb5c5d972e67df545b6d6fb5703dc910b20c28474202df0b1ddcb28e604f351d"
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
  depends_on "python@3.13"
  depends_on "readline"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", *std_configure_args,
                          "--disable-silent-rules",
                          "--with-python=#{which("python3.13")}",
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
