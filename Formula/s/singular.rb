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
    rebuild 1
    sha256 arm64_sequoia: "896fbb9eef9f94af1eaf50f0b9aa74349fa09c4af793afb5750191528d8abd2a"
    sha256 arm64_sonoma:  "f5af6764654d8eb0bc0d37ad92eb4604d89d0d6948b567207305a97b06131a9a"
    sha256 arm64_ventura: "25dbec84237a3a91179bb8821cc467380db5e9a6afb0c527c1892df8e7cc953b"
    sha256 sonoma:        "fa44347fa78090b4159d95f152c2c1b44e139543366733e8999a7b7550a0993d"
    sha256 ventura:       "45495c62336592f855eb8ce7a6bfe65317d3ebb09ef283e7a44a7b514e43d2bc"
    sha256 arm64_linux:   "1c40c1d54986a5fe26d7b9be4c6ad059b910afb0289c145e4373c895526d74c4"
    sha256 x86_64_linux:  "6648ecbf457333344ef6c772f27c9dc60e54deff011f4c211ddb5b3a1fa9dcfd"
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
