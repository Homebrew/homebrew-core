class Remake < Formula
  desc "GNU Make with improved error handling, tracing, and a debugger"
  homepage "https://bashdb.sourceforge.io/remake"
  url "https://downloads.sourceforge.net/project/bashdb/remake/4.3%2Bdbg-1.5/remake-4.3%2Bdbg-1.5.tar.gz"
  version "4.3-1.5"
  sha256 "2e6eb709f3e6b85893f14f15e34b4c9b754aceaef0b92bb6ca3a025f10119d76"
  license "GPL-3.0-only"

  # We check the "remake" directory page because the bashdb project contains
  # various software and remake releases may be pushed out of the SourceForge
  # RSS feed.
  livecheck do
    url "https://sourceforge.net/projects/bashdb/files/remake/"
    regex(%r{href=.*?remake/v?(\d+(?:\.\d+)+(?:(?:%2Bdbg)?[._-]\d+(?:\.\d+)+)?)/?["' >]}i)
    strategy :page_match do |page, regex|
      page.scan(regex).map { |match| match&.first&.sub(/%2Bdbg/i, "") }
    end
  end

  bottle do
    rebuild 1
    sha256 arm64_monterey: "d18b85f939c05f0d73b7b854a908804f1747b0e8c21f0ac4fdd672efd8a99cab"
    sha256 arm64_big_sur:  "391321a2121b244a77d91ffb3ec32d039aa38445441bff436f6128164b51db16"
    sha256 monterey:       "114032168dffef067d1f68d3ea7a05c265f00892c596b60fdf2ed0ccabf824d3"
    sha256 big_sur:        "933b00f621a8cfc69a197d73bfe7f9d319d3571aae991eb3b039a8471ea9a0f1"
    sha256 catalina:       "310b2ef02888a953487fb4e3f7fd7101c209a9abd12286d6a8509669c3ed2909"
    sha256 mojave:         "05998e7ad1f8442b57e0826b5152894186f359b59d75e68634c1da1a96b0345f"
    sha256 high_sierra:    "b3c14a7963aeda5e8367e0e4375354fdd58b24a99c07d6cb3fd881dc8d1b1941"
    sha256 x86_64_linux:   "1f2cd2a87eb12abde96e7a815352db577e6600ec495b261ef75cd61b8a744dc0"
  end

  depends_on "readline"

  conflicts_with "make", because: "both install texinfo files for make"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"Makefile").write <<~EOS
      all:
      \techo "Nothing here, move along"
    EOS
    system bin/"remake", "-x"
  end
end
