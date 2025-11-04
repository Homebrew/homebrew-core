class Swfmill < Formula
  desc "Processor of xml2swf and swf2xml"
  homepage "https://www.swfmill.org/"
  url "https://www.swfmill.org/releases/swfmill-0.3.6.tar.gz"
  sha256 "db24f63963957faec02bb14b8b61cdaf7096774f8cfdeb9d3573e2e19231548e"
  license "GPL-2.0-only"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0917b9af1eecad6661e8e9fa3452013b0b902f51a00e8fc9eadf86ea8f1a887f"
    sha256 cellar: :any,                 arm64_sequoia: "279d5dd1836fce59c3f06ff29a2a773802fed981a15f2be361cd16b0b33529cb"
    sha256 cellar: :any,                 arm64_sonoma:  "16ccf2bac17d2fdcc617a6046afd6e661d3cff9adb2d6d7dbe1c7cd2d381fd37"
    sha256 cellar: :any,                 sonoma:        "efd2b5bb9d62a7450499a95361daf04822b306bf26e170ea8797fe83df951234"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "49b40a53fc3a91359c32d504914b4552c2921a0b93342c16245c86ea727ac69c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9633e3f5f02761950f52d4669c0dc43d18ae88a07303e8c2a1e37a1055a9ee05"
  end

  # adobe flash player EOL 12/31/2020, https://www.adobe.com/products/flashplayer/end-of-life-alternative.html
  deprecate! date: "2025-01-12", because: :unmaintained

  depends_on "pkgconf" => :build
  depends_on "freetype"
  depends_on "libpng"

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"
  uses_from_macos "zlib"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end
end
