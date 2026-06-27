class Wandio < Formula
  desc "Transparently read from and write to zip, bzip2, lzma or zstd archives"
  homepage "https://github.com/LibtraceTeam/wandio"
  url "https://github.com/LibtraceTeam/wandio/archive/refs/tags/4.2.7-1.tar.gz"
  version "4.2.7"
  sha256 "45021795b5c4d1609ba509358e730ea605c4c9621704d75214abb003f37602ab"
  license "LGPL-3.0-or-later"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:[.-]\d+)+)$/i)
    strategy :git do |tags, regex|
      tags.filter_map { |tag| tag[regex, 1]&.gsub(/-1$/, "") }
    end
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "56ba2de2f56757135f4e1c9d46641493dde28ba90b355508d245bf2ce21197c1"
    sha256 cellar: :any, arm64_sequoia: "e56952eebbac33e9e4fca5a66b9dbde26a7cca8ff2deb2aeb3fde9dd1ab93c2b"
    sha256 cellar: :any, arm64_sonoma:  "99dd94a319b9517c0429e5e0697a2a604aee164c90ad6242a5eaa870b4ff705b"
    sha256 cellar: :any, sonoma:        "4a020f80eb8e8a164c697d3a0650fe852b5fd1ca07f3da301da5a682775c2871"
    sha256 cellar: :any, arm64_linux:   "be506895e4d94dfc0a339377a1c8ee14e6410421eade2f0c513317f1ceb55646"
    sha256 cellar: :any, x86_64_linux:  "1614fe1d92fc980cb7221900d99a477a078767cb8c61ae237d3d4026a4fa4c62"
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
