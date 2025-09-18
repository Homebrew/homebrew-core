class Singular < Formula
  desc "Computer algebra system for polynomial computations"
  homepage "https://www.singular.uni-kl.de/"
  url "https://www.singular.uni-kl.de/ftp/pub/Math/Singular/SOURCES/4-4-1/singular-4.4.1p3.tar.gz"
  version "4.4.1p3"
  sha256 "3039ae047c5be87616554e87197ca4dda6ad700c1909ae593ae649b573b339c7"
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
    sha256 arm64_tahoe:   "632d56046512fdf19ffff2c9dbd8ac58340e10d350862c4535be917f29d7fa95"
    sha256 arm64_sequoia: "4d97010dc5d346e1f82df6387f54a14ae99473a8b8c8c7ecc4cdae5a447a9789"
    sha256 arm64_sonoma:  "4730fff20ec2cbf892142df2f9c73e82310eaea3f2ffb5725aae4c211cedef58"
    sha256 arm64_ventura: "5899af2ebaf5d16d042f58f0c6fa916d62bd6230272716f899a2b73ea34c94d2"
    sha256 sonoma:        "1c58a077da05431364afaab9640f6fe6e25c460533d49eefd55b9f18384f0c87"
    sha256 ventura:       "6d278286d07df70d84124d9a3d70c27587aff29f2ad883c24c9065bbe45f65ed"
    sha256 arm64_linux:   "729150f3dae912cd58d85c3dec41b9caa6fd20ebe36dbda6085375758db6f7c4"
    sha256 x86_64_linux:  "57e053c8ebbfb1f9d3945a91c9d1fb83c7b78ff82a5d8ba995bb76a9fd24fe91"
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
