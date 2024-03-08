class Singular < Formula
  desc "Computer algebra system for polynomial computations"
  homepage "https://www.singular.uni-kl.de/"
  url "https://www.singular.uni-kl.de/ftp/pub/Math/Singular/SOURCES/4-3-2/singular-4.3.2p16.tar.gz"
  version "4.3.2p16"
  sha256 "675733ba13a6ec67c564e753139f7c0c4b0d3e29bdb995de5341b616f1472a16"
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
    sha256 arm64_sonoma:   "f0bddb5da1c198e218dcd79b585cf0398770f9decbf5b2ac454721ecb0f5d015"
    sha256 arm64_ventura:  "e4a22b79e5ccf17a46e0ce271cdf61ba32d7459e8f6d24a0e256af3dfc5957e2"
    sha256 arm64_monterey: "098334fdfc30955cb547398be691c51e4946ab5ebdfc904f08313ce77a1aefc7"
    sha256 sonoma:         "7ed4d7303a1267240d6361547b46f98219b153032c47667c60e500eeb4d90b2d"
    sha256 ventura:        "b8be00bbe12c3807b700663611d8a566cb87b1cd6f807e67bf49ec2df92e40e3"
    sha256 monterey:       "b6b9a45728e90034875d3cfd1bdaf39bd2081e00d84bead8f920ae19047b23f4"
    sha256 x86_64_linux:   "64c5c20f4a2d54099bb692ec0a7af371fbd19b81ecd197c7dc0ac5167d0dfb7e"
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
  depends_on "python@3.12"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", *std_configure_args,
                          "--disable-silent-rules",
                          "--with-python=#{which("python3.12")}",
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
