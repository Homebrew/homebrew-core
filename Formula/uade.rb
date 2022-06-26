class Uade < Formula
  desc "Play Amiga tunes through UAE emulation"
  homepage "https://zakalwe.fi/uade/"
  license "GPL-2.0-only"

  stable do
    url "https://zakalwe.fi/uade/uade3/uade-3.02.tar.bz2"
    sha256 "2aa317525402e479ae8863222e3c341d135670fcb23a2853ac93075ac428f35b"

    resource "bencode-tools" do
      url "https://gitlab.com/heikkiorsila/bencodetools.git", revision: "5a1ccf65393ee50af3a029d0632f29567467873c"
    end
  end

  livecheck do
    url "https://zakalwe.fi/uade/download.html"
    regex(/href=.*?uade[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "1fa83a9d0afe0133189cc075e9eb0e8822e21baa01d0e568e768f65949cfd567"
    sha256 arm64_big_sur:  "9e2786bddc15f0864674e26e53032af89c07490f7aca0aff307186cdd0eef283"
    sha256 monterey:       "d58fbf04c9fcb13f046a76110aeebf25cb93c3d812ed2a5ec04f3d93cc82424e"
    sha256 big_sur:        "42cef81cd6f1792dc53c8e14a8fc416dadac072bf08a8bbf568838c9ae758ea1"
    sha256 catalina:       "923523028dcc4fd1e98df962874d7385bfbc658c894216ff64dac85ab13616fd"
    sha256 x86_64_linux:   "b570d5bee780acb48d04b1915026fbbbea8bf38ec3f217e24129bd4904470174"
  end

  head do
    url "https://gitlab.com/uade-music-player/uade.git", branch: "master"

    resource "bencode-tools" do
      url "https://gitlab.com/heikkiorsila/bencodetools.git", branch: "master"
    end
  end

  depends_on "pkg-config" => :build
  depends_on "libao"

  def install
    resource("bencode-tools").stage do
      system "./configure", "--prefix=#{prefix}", "--without-python"
      system "make"
      system "make", "install"
    end

    system "./configure", "--prefix=#{prefix}",
           "--without-write-audio"
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/uade123 --get-info #{test_fixtures("test.mp3")} 2>&1", 1).chomp
    assert_equal "Unknown format: #{test_fixtures("test.mp3")}", output
  end
end
