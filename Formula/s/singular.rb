class Singular < Formula
  desc "Computer algebra system for polynomial computations"
  homepage "https://www.singular.uni-kl.de/"
  url "https://www.singular.uni-kl.de/ftp/pub/Math/Singular/SOURCES/4-4-1/singular-4.4.1p5.tar.gz"
  version "4.4.1p5"
  sha256 "bce5a40bd10b6e9fe991de97e6284f62cdb566c8aef4b2836b4d1307eb7d9edf"
  license "GPL-2.0-or-later"
  revision 2

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
    sha256 arm64_tahoe:   "c081b623d6af7e66dbb507cea3fdbb241a3d435d90e6cc2e840cbf771abc0d23"
    sha256 arm64_sequoia: "4ef435787abe4a66d8a28d8862aee593fa3db289d378033d64ceeb8392648da8"
    sha256 arm64_sonoma:  "786c72443b96a85854d4787ddd4fa1dde98457c95f23eca425ae4ea46cc7e2bb"
    sha256 sonoma:        "5ca88e6511bb66745b3e203778a4964f50d55e12dcec48887903d78c2655a19c"
    sha256 arm64_linux:   "240325787cfca84c7e6a5eb4b4100650476a715467b327c11437fb364fd75ef1"
    sha256 x86_64_linux:  "7ba967e5ed6bd9e265becbfab588182824ad34973c96532a2ceb9773bc7b6193"
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
