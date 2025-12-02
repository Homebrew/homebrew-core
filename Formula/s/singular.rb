class Singular < Formula
  desc "Computer algebra system for polynomial computations"
  homepage "https://www.singular.uni-kl.de/"
  url "https://www.singular.uni-kl.de/ftp/pub/Math/Singular/SOURCES/4-4-1/singular-4.4.1p5.tar.gz"
  version "4.4.1p5"
  sha256 "bce5a40bd10b6e9fe991de97e6284f62cdb566c8aef4b2836b4d1307eb7d9edf"
  license "GPL-2.0-or-later"
  revision 1

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
    sha256 arm64_tahoe:   "531f23bff6faf97c1138bf8cdab032b443ca29ff9da7fdb216edcf1725325c6b"
    sha256 arm64_sequoia: "e635137a9da900f3aacf0c857b368e0aa518f19a1b75876c47388647d99a120f"
    sha256 arm64_sonoma:  "2242a315a91da65df1732af79728adcb0c725a654ea26e09210570709b6bef76"
    sha256 sonoma:        "b42e668e2d9fec7d3b177b4301d6cb4f8fd656a45873860355d8c7dce58e72b4"
    sha256 arm64_linux:   "5073d73746fabf41d5c4a54c4a905476e2092b8eb178245e9170f3575d779422"
    sha256 x86_64_linux:  "b5afffd6561c4d392f53700e22de548aa57d4e417891bb0bcee8a2e748cdf3a9"
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
  depends_on "python@3.14"
  depends_on "readline"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-silent-rules",
                          "--with-python=#{which("python3.14")}",
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
