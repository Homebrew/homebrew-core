class Radare2 < Formula
  desc "Reverse engineering framework"
  homepage "https://radare.org"
  url "https://github.com/radareorg/radare2/archive/5.6.6.tar.gz"
  sha256 "ef934b786cce10bf16e9e0b0fd3b3d338af33a83ae83bbd50101facc39549961"
  license "LGPL-3.0-only"
  head "https://github.com/radareorg/radare2.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_monterey: "f3ba5972f5a6769243d94689a655ee855d73208f0416fe164d3940cd3f204bfe"
    sha256 arm64_big_sur:  "f0ed5318a8cb7deb30562f35f242eba92360e4499e107c01a030789d8d66b114"
    sha256 monterey:       "6393cdfc82df9688af34e6b1cb1ea85f48df53fcbddc4bd26dff77f4c311c98a"
    sha256 big_sur:        "821292aaa5abbbe813394d7f08b3ab23aecef90ada174ebea7bace17d064b071"
    sha256 catalina:       "ce8fb617057c9637ccc4c77ee352aad809b519961ffc0a40c1e3fec38e88409a"
    sha256 x86_64_linux:   "ea5b34898e785fe6db87213855a2c94243193e47b1da9a7cba3a736308b42fa0"
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
