class Radare2 < Formula
  desc "Reverse engineering framework"
  homepage "https://radare.org"
  url "https://github.com/radareorg/radare2/archive/5.7.6.tar.gz"
  sha256 "1e798504a978929803ac7d6e42530b06c44be7e1abb5842877a88d7a34d9fd8f"
  license "LGPL-3.0-only"
  head "https://github.com/radareorg/radare2.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_monterey: "8ca0d62cfd69329aa64e630ceb43c063b0c192896e2f1e286b156ac42c7d0af0"
    sha256 arm64_big_sur:  "524ec08f9549d596ad221c96b495e69be355c0002ffe26bf1ba1a5a6c5a4712b"
    sha256 monterey:       "2f9b155739c47cffa8b7414681474acf554acb74c7e60bceb32fbf15552ebbf3"
    sha256 big_sur:        "e3a02430f77db35883c6e5466b80f9448c6c49de3456ae52d9f0eef5a9a258aa"
    sha256 catalina:       "925223ed86152fc49e3903fe7325b1429a4cf0a67b6ebe3842467de79037981f"
    sha256 x86_64_linux:   "9542846b817c08cfb9ca742119ba80da8aa43e51999bb966c54f81ca0f91ee30"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    assert_match "radare2 #{version}", shell_output("#{bin}/r2 -v")
  end
end
