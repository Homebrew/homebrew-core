class Singular < Formula
  desc "Computer algebra system for polynomial computations"
  homepage "https://www.singular.uni-kl.de/"
  url "https://www.singular.uni-kl.de/ftp/pub/Math/Singular/SOURCES/4-3-2/singular-4.3.2p9.tar.gz"
  version "4.3.2p9"
  sha256 "f3201c348291e4352979d4ff612f37bf8b3f6b72dedde5d1f293bab3f5b22ee1"
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
    sha256 arm64_sonoma:   "34f9ff02e15e18cc7aa72a44ca02c957ae312b0efac0df3f73ad847db5004ea9"
    sha256 arm64_ventura:  "4ea6c662661ea3bb87c4f3ba5a8fdf2a6aaf99c491b207ebbeccc237d44af220"
    sha256 arm64_monterey: "df243b669316e7077e28ac11c6a3a2bb1c21a0dd6d55a3bf893278651f772393"
    sha256 sonoma:         "1cf8bdda2a056a6cb65504fbb33783992aa9ebe7798a91441928062970881a50"
    sha256 ventura:        "54b0f489409c5b33732a2d3ab3effee4ae262f82699b1ab37e849d0a1f64eb59"
    sha256 monterey:       "6d3b8b6ba1bb1e99a3a447ad79b6e0bec3174589d61d7810e209e1c9a0af2f57"
    sha256 x86_64_linux:   "18b243f9ce09edbdda42ea2bb20e85bb9590a92c6f7d6c69a1b348807c950d96"
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
