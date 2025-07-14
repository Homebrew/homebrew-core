class Singular < Formula
  desc "Computer algebra system for polynomial computations"
  homepage "https://www.singular.uni-kl.de/"
  url "https://www.singular.uni-kl.de/ftp/pub/Math/Singular/SOURCES/4-4-1/singular-4.4.1p2.tar.gz"
  version "4.4.1p2"
  sha256 "7096f9f8d7bcc8e43be4a9521fb54cf685abf4ec14bd0870aa6a820cbd4648aa"
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
    sha256 arm64_sequoia: "b3dbf31901b8423556e9cacfa4fcf1c8d32a6180d742995c34ad702b8faa4f35"
    sha256 arm64_sonoma:  "a4406c1b3b2d19a8781666a69111a0768a043bcda26fb1ae5239569f19bb805d"
    sha256 arm64_ventura: "09c9b0481ace420791af5e7c317f1d5292623c775cb24fc5b4f21078499a5ab0"
    sha256 sonoma:        "eb62e1ef508b00fa04b7579aff5a3518c4dc5502ac56978185cd3928199c9d4f"
    sha256 ventura:       "c9873b833be991bcd211690e9ba63b34bfc5f6d89e838b385657778d1a18a078"
    sha256 arm64_linux:   "b11bfd4da5163104c2be7977f1fd515ed69a1819dcaaec78dda1bdd177195cfd"
    sha256 x86_64_linux:  "4ae08c2a869756e6c8c35919bcfa713172c2db63e9225af936460608806bc42f"
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
  depends_on "python@3.13"
  depends_on "readline"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-silent-rules",
                          "--with-python=#{which("python3.13")}",
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
