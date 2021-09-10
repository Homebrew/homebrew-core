class Radare2 < Formula
  desc "Reverse engineering framework"
  homepage "https://radare.org"
  url "https://github.com/radareorg/radare2/archive/5.4.0.tar.gz"
  sha256 "21ddae80a18d5ceef4bcd3a7cae1ba09d14b510d68ac9134681e1e9967123b23"
  license "LGPL-3.0-only"
  head "https://github.com/radareorg/radare2.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_big_sur: "c9420b9764e18ebccc52291a2de1542d67e53da4d6ce69ee6896c9e671e92305"
    sha256 big_sur:       "6301d3a8c7436d93624a8711cf0de3931bceeec6b5d7299da3c5a21bb1a98393"
    sha256 catalina:      "a76737b1fd039839b1f9240a3707d6c3f04c8ae13cebacc22a7d7383bcc61b22"
    sha256 mojave:        "a0923d893643c86f4d415c0a5433e605cbcf29dfaaf917b5272ff306b3876c71"
    sha256 x86_64_linux:  "2b803424544a47c2b8b3b3a7c4a8397c5851ace5141408b2d13128ea0739a7e5"
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
