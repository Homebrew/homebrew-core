class Singular < Formula
  desc "Computer algebra system for polynomial computations"
  homepage "https://www.singular.uni-kl.de/"
  url "https://www.singular.uni-kl.de/ftp/pub/Math/Singular/SOURCES/4-4-0/singular-4.4.0p3.tar.gz"
  version "4.4.0p3"
  sha256 "4798dddcc4cb51f1cba5114a5cb4783708b9ab4b7d5e9136cb264eb62190c706"
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
    sha256 arm64_sonoma:   "df90cf528751add9b8c731f38e24f505b0fb97b2770ec239e339a466ad5b3326"
    sha256 arm64_ventura:  "fa58c28b2159bf0b69f1ec8df8b4272e275cf0d0b2df0b4651038633f4d243ed"
    sha256 arm64_monterey: "b93453f125930878685a4fd36bda3afea2f7615352342f324f5eb8e48fd77572"
    sha256 sonoma:         "0f683fd0f8cc9ae211192f20f9738f754ea88b98b84db2d5d933a6eaf25925e1"
    sha256 ventura:        "16c7c628e03a914154d2f669cd341a5c6f3a3e5ba49dc2e2f1ba5d9985a29bc2"
    sha256 monterey:       "7f4ee66f46a214f8cc8ee9b7bcd806db43c1de7870a3512c75b4558f16ada457"
    sha256 x86_64_linux:   "007048fff88004772068aab05932d9b43a4a91119da9c6fe5182bee55ad0102c"
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
  depends_on "readline"

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
