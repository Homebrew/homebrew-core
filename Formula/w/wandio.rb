class Wandio < Formula
  desc "Transparently read from and write to zip, bzip2, lzma or zstd archives"
  homepage "https://github.com/LibtraceTeam/wandio"
  url "https://github.com/LibtraceTeam/wandio/archive/refs/tags/4.2.6-1.tar.gz"
  version "4.2.6"
  sha256 "f035d4d6beadf7a7e5619fb73db5a84d338008b5f4d6b1b8843619547248ec73"
  license "LGPL-3.0-or-later"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:[.-]\d+)+)$/i)
    strategy :git do |tags, regex|
      tags.filter_map { |tag| tag[regex, 1]&.gsub(/-1$/, "") }
    end
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "5673ce841d6d082afc1432971b3b2e28596c4f931aa409b22f86e74317039ec4"
    sha256 cellar: :any,                 arm64_sequoia: "ad387944b49303444e1a8216a656e20bed139bc0c6d689310f582077b19d0767"
    sha256 cellar: :any,                 arm64_sonoma:  "76f48d461a4ddef56aa15f61c6e758d64da0dbd1abc9ee25daff508765ce828f"
    sha256 cellar: :any,                 sonoma:        "8ee2891b8d44dbcf55985d9b08528b728c097704e5479e8c82b5d863f949246d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e9be468d23893b34c86f3c4f6bb69ec719f82174b8e876d3a6a86f59afa64288"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "89523d49509881d50d6e96f15f1c36127f38ba6b8337c9f0dd7b08dc3075389a"
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

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "./bootstrap.sh"
    system "./configure", "--disable-silent-rules",
                          "--with-http",
                          *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"wandiocat", "-z", "9", "-Z", "gzip", "-o", "test.gz",
      test_fixtures("test.png"), test_fixtures("test.pdf")
    assert_path_exists testpath/"test.gz"
  end
end
