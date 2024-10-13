class Singular < Formula
  desc "Computer algebra system for polynomial computations"
  homepage "https://www.singular.uni-kl.de/"
  url "https://www.singular.uni-kl.de/ftp/pub/Math/Singular/SOURCES/4-4-0/singular-4.4.0p6.tar.gz"
  version "4.4.0p6"
  sha256 "23a7674d1cf734b436c26c145dc22cb51f71a14d61e6ca17084293ccd0148902"
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
    sha256 arm64_sequoia: "2545817c2a3bf6805ec8d6c0f4b68bdbf79f2b0e806f0960d41b469a1a354b00"
    sha256 arm64_sonoma:  "8799c07b7d704e30890bed5683754edd5985455ef9f564042627dd245d76f4ef"
    sha256 arm64_ventura: "3a9129e0e3b233f981cb6af0f407c71fc8993a22f703d0b7f7a4509dfabd01c4"
    sha256 sonoma:        "8c7a0a365cbf858612410deaeacb8d21aeb000436f0e2d37d99dd171198932d1"
    sha256 ventura:       "c310798143fff1172ddf0e53cebf57971a4cbea620e13310777a3a6e54c6a0f4"
    sha256 x86_64_linux:  "242776f9cf894709375ec5971dca826231e9f6417f38b7945988ae2197d7d0e8"
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
