class Singular < Formula
  desc "Computer algebra system for polynomial computations"
  homepage "https://www.singular.uni-kl.de/"
  url "https://www.singular.uni-kl.de/ftp/pub/Math/Singular/SOURCES/4-4-0/singular-4.4.0p2.tar.gz"
  version "4.4.0p2"
  sha256 "68ef014cd52006399c09160f447191e36bda28dd5d64d251a577fae7eae237f1"
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
    sha256 arm64_sonoma:   "662443efbfa2dd899e3f4a3d8cb5168999781f8896e6f1bde4d1a39c1b60c1b6"
    sha256 arm64_ventura:  "72a7bb2e05c6b576cda411328f06bcd3b28e694d207404646da9ff704aa19895"
    sha256 arm64_monterey: "f1040d685a7a6535b08944336b4409a234be1375fc4bf983ace27584d937488e"
    sha256 sonoma:         "93da86cd228684530a72e3252a9fe543c8683b85551c319890a2478e21c4acae"
    sha256 ventura:        "891c215e9c3752e4dcafb375f4274249b000a2b7178f2a4fe28b0824199e90c0"
    sha256 monterey:       "2d6c2b68857bc630bbb4ce6537df446019548cb578d583e0bdc36cc30345a998"
    sha256 x86_64_linux:   "b9931407800d5a13426e24b891693a39981f6ba217dad4adb130f5b2948bb33d"
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
