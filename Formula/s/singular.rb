class Singular < Formula
  desc "Computer algebra system for polynomial computations"
  homepage "https://www.singular.uni-kl.de/"
  url "https://www.singular.uni-kl.de/ftp/pub/Math/Singular/SOURCES/4-4-1/singular-4.4.1p5.tar.gz"
  version "4.4.1p5"
  sha256 "bce5a40bd10b6e9fe991de97e6284f62cdb566c8aef4b2836b4d1307eb7d9edf"
  license "GPL-2.0-or-later"
  revision 3

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
    sha256 arm64_tahoe:   "a0eff7f1303dadf6e87f32dc2db2e12df0a3371b845ec473b0cc51763d20a9f5"
    sha256 arm64_sequoia: "8d44a9cdae5e24cfa477aa87070c9059dd035a4a4b66ec4b14e687caeb807167"
    sha256 arm64_sonoma:  "80b04fa26d0a5a030c12dcd8be639e4280fb37d8a1d71275b7d2fcd897afb3ae"
    sha256 sonoma:        "212d418cdc0a39095885e3e0264cd0a22306efd9eef6b59588d42964a008a651"
    sha256 arm64_linux:   "86c09cc2f0763660ed70c7884c56355f6671593788e4e95b0b6ccc91ce15a7ef"
    sha256 x86_64_linux:  "c52d7d0daf52fe19d132da3d33a2e33f769c407d6ae69ede03c81401ec7072d9"
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
