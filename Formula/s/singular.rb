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
    sha256 arm64_sonoma:   "101500912b78329b856a9faf1b3267466fc82e7bdb59d10d1849a90d8bd53269"
    sha256 arm64_ventura:  "f81833d0f7a0f63447d99974989e6ee6faed19b9952ac49e7d4e226a5360c869"
    sha256 arm64_monterey: "82f3007f90f677e434132809493852e3b9fb662fc9ca16b07b6002a45e1e84e3"
    sha256 sonoma:         "ddba9784c1d2a8be82ce87c00f16ff863572f60df6e3696e5a0f59238c9b079b"
    sha256 ventura:        "3e46f2cb8e5792c64b8243b2da1487e69246dfb6ca59448938d612d2228428cc"
    sha256 monterey:       "7d73bd60a946e44ab0be78fa148c9d1ed4684e7d184a1bbf9a65148e3898867c"
    sha256 x86_64_linux:   "aaa222a5f55aa0c399564f75fe8e91f2853085c86b45993a16100b9a5c0dd514"
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
