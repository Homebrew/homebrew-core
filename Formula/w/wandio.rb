class Wandio < Formula
  desc "Transparently read from and write to zip, bzip2, lzma or zstd archives"
  homepage "https://github.com/LibtraceTeam/wandio"
  url "https://github.com/LibtraceTeam/wandio/archive/refs/tags/4.2.5-1.tar.gz"
  version "4.2.5"
  sha256 "349d2ac8f3c889a241ff6a85d47b36269de8352b761da8ff9cfa6940244066e2"
  license "LGPL-3.0-or-later"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:[.-]\d+)+)$/i)
    strategy :git do |tags, regex|
      tags.map { |tag| tag[regex, 1]&.gsub(/-1$/, "") }.compact
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "420c0f7905421d2291795c2148e495a0a0dd9dbf9634d42be0e2938b2a8801a6"
    sha256 cellar: :any,                 arm64_monterey: "01d44b20c09f399e419508c2136c58c6baf41708b86f0f90efb6959c2b8cb8d3"
    sha256 cellar: :any,                 arm64_big_sur:  "0b4c435704cbe614f434e7186a34dda5d8231e66c7e278d38d15c3b3ea7d3a10"
    sha256 cellar: :any,                 ventura:        "c378f4220cfad85721d03f2e71fada85eb062b02464f14c964b53b07bb3a9f8a"
    sha256 cellar: :any,                 monterey:       "267f7e45ce3dacb7b49500c335544133d04481b1ec59b540896f5132fb603820"
    sha256 cellar: :any,                 big_sur:        "8cb66a137b8a81357ae188ebfd2478bf0220ba428b0f0de8c2e45a32cdb43aa4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9cb83f00594d9d8a7ac2b718249a3a89d429bddfad5a5ec4d99c27f39157735b"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "lz4"
  depends_on "lzo"
  depends_on "xz" # For LZMA
  depends_on "zstd"

  uses_from_macos "bzip2"
  uses_from_macos "curl"
  uses_from_macos "zlib"

  def install
    system "./bootstrap.sh"
    system "./configure", *std_configure_args,
                          "--disable-silent-rules",
                          "--with-http"
    system "make", "install"
  end

  test do
    system "#{bin}/wandiocat", "-z", "9", "-Z", "gzip", "-o", "test.gz",
      test_fixtures("test.png"), test_fixtures("test.pdf")
    assert_predicate testpath/"test.gz", :exist?
  end
end
