class Singular < Formula
  desc "Computer algebra system for polynomial computations"
  homepage "https://www.singular.uni-kl.de/"
  url "https://www.singular.uni-kl.de/ftp/pub/Math/Singular/SOURCES/4-4-0/singular-4.4.0p6.tar.gz"
  version "4.4.0p6"
  sha256 "23a7674d1cf734b436c26c145dc22cb51f71a14d61e6ca17084293ccd0148902"
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
    rebuild 1
    sha256 arm64_sequoia: "ac4346f71a06f0ae9ec36bdc498414d61cd9b6161f39ebfa4327817423f96e9e"
    sha256 arm64_sonoma:  "4e18563cd04ba72fe3c22cc9a1146b21e02b14427adba5363bc5a9ca681604af"
    sha256 arm64_ventura: "559b2f2a8d17deae3d3e47e1f0cfabf047e35c87232a7a59b1fb482a0b23e671"
    sha256 sonoma:        "697102f51dc8667ddf7773a52ebae51f150cb15b248491c465ac653d9ce364a2"
    sha256 ventura:       "7a114e9f033ff75acb94bf101359e68c63874b8698c85b71807fd82ac518fbe7"
    sha256 x86_64_linux:  "1da41f69eaeba4d66f62b448514235837cfecc2193a433610bd18528eec35f3b"
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
