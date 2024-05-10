class Singular < Formula
  desc "Computer algebra system for polynomial computations"
  homepage "https://www.singular.uni-kl.de/"
  url "https://www.singular.uni-kl.de/ftp/pub/Math/Singular/SOURCES/4-4-0/singular-4.4.0.tar.gz"
  sha256 "c269abbd24c84fe33edc0af1e78b8fec53d8e94338410ac06c2666cfd40d43f2"
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
    sha256 arm64_sonoma:   "27981ca3142ace51582e088ffd260cb392c59b3d57bbcc077f0e462da81f5e1b"
    sha256 arm64_ventura:  "6fc3a702ab9649c27183312a9723f89b269bd68940959d5d5893bfc6b6e5e32e"
    sha256 arm64_monterey: "489f1752265b21938dbdf0e35677ab47f9fb4a25f98c61554c3e4a18d6fef534"
    sha256 sonoma:         "7d8835a5c15aa151f3b3e27115f80656201714ca49e5b11f78fdbb6d42ffa9f4"
    sha256 ventura:        "faaf92384014885c55a79b6f27a5a6f8ffa13416b67bcf671d8be9419f46fefc"
    sha256 monterey:       "8391ba8c8033ce2cbc8bbebc2078a1f9e5bc4224d6b05a8595ccb35292196c3c"
    sha256 x86_64_linux:   "0243865988a3e1fc899ec2fb6cc61b8fc01160b81fd72f978c4f03bbada58534"
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
