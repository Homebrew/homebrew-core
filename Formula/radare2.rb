class Radare2 < Formula
  desc "Reverse engineering framework"
  homepage "https://radare.org"
  url "https://github.com/radareorg/radare2/archive/5.7.8.tar.gz"
  sha256 "084f262873f7ebbb54cfe01ebf14b43136e5a7442df8ecf01b37e7060a49b432"
  license "LGPL-3.0-only"
  head "https://github.com/radareorg/radare2.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_monterey: "290c7bdac09de70780f68335b073ca05556bbbf4e46e1728c7dff40239003117"
    sha256 arm64_big_sur:  "966640058eb878b3d521d6651e66b185ae26cab5a0cf30253d6b742f2f98b6d3"
    sha256 monterey:       "a7b4d21522a7d6db8178f2a7f14fbadab9c70723ba269fded6ee255d1864e1da"
    sha256 big_sur:        "72fbe1bef881d08485cb0861f6ea80501ecaa95cdbecf69491871f2a94b4af3c"
    sha256 catalina:       "3185b7d98b85b505be5ef3bb07babe7e1f536a87d0e7feea0b1c2709a6b4fc92"
    sha256 x86_64_linux:   "56d668407326f8fbe3bfe5d4f2a198284a14ff4f93b2183b1bc8390783d5a36f"
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
