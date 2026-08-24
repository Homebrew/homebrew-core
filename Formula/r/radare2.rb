class Radare2 < Formula
  desc "Reverse engineering framework"
  homepage "https://radare.org"
  url "https://github.com/radareorg/radare2/archive/refs/tags/6.2.0.tar.gz"
  sha256 "60b31af14772cdcff1703a80f51558dbdf2ee6c114768ca51ca2033fb4bd534b"
  license "LGPL-3.0-only"
  head "https://github.com/radareorg/radare2.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "533d4f4051043a7901fc99cded9f64bbb30c3333603021db028c75dc2ef3dba2"
    sha256 arm64_sequoia: "7164b34f8be70826028de8121910a0c9837bf558ccfbb1ca321a4ada4b08af17"
    sha256 arm64_sonoma:  "d2582b81bc054849e3a11f569071f0b84d936d80429cd22b6e022a2bfd77383d"
    sha256 sonoma:        "b277eb0bb50104751219f710064bbb866098211d759d0af51ee214827bf393ea"
    sha256 arm64_linux:   "9db7dedc276423393b932a737edd3aec795720b001c438cb311ff87017d67cc7"
    sha256 x86_64_linux:  "dd373c47645405d6aa8482d1b78488986cd83b766d322bb85ef0186c1ff398ac"
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
