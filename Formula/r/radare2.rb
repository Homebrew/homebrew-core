class Radare2 < Formula
  desc "Reverse engineering framework"
  homepage "https://radare.org"
  url "https://github.com/radareorg/radare2/archive/refs/tags/6.1.6.tar.gz"
  sha256 "7370c52cb22cba3ab02ee77970fd258a8ecdbf3fd3282f2647ff12393c6ae8ac"
  license "LGPL-3.0-only"
  head "https://github.com/radareorg/radare2.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "a51e7dcdae2b55558e3c8693dd38d432d95fc98322b6e74dd91449da97acfe6a"
    sha256 arm64_sequoia: "9294d46455639c1e0bede5a6319dd2d913d40c1024fc5931c9ca632d8c923070"
    sha256 arm64_sonoma:  "92f5c4004a480829354fb1adfe6320be39087c220564fb63ac691f893dd9e7ff"
    sha256 sonoma:        "248cc01b3e827a45634482da31bbcb8de21a747a7ba2143c80b2262fa9023d79"
    sha256 arm64_linux:   "d6051989e67d9d515923bee79aa487fbe58115ad792b2300fb4b2808724d64d5"
    sha256 x86_64_linux:  "bd3afcdb2dbd5838355e4a50eab189590e802561e9ddfa0a0a25053294566d1f"
  end

  # Required for r2pm (https://github.com/radareorg/radare2-pm/issues/170)
  depends_on "pkgconf"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    assert_match "radare2 #{version}", shell_output("#{bin}/r2 -v")
  end
end
