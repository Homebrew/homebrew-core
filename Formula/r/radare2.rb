class Radare2 < Formula
  desc "Reverse engineering framework"
  homepage "https://radare.org"
  url "https://github.com/radareorg/radare2/archive/refs/tags/6.2.6.tar.gz"
  sha256 "ef5ae9a0785be28ff38ea61e3b1351232c068691868bab98613c67a8b7aa4872"
  license "LGPL-3.0-only"
  head "https://github.com/radareorg/radare2.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_golden_gate: "0bed9020b7c86c96978a80d221fdec515465fc40cc18c57355b795c788a56c94"
    sha256 arm64_tahoe:       "71ea634a42bc91f525bf64100e7e6a7289c469e9ce00a65bcafcb7a4aeef20cf"
    sha256 arm64_sequoia:     "99e156b9163a7617f6573ac804cbecee9066db97a99c0d38f166ff1c610f16d4"
    sha256 arm64_linux:       "620641c6471c49f1575cb15f767af30ae42652574228e6fb93259c471abf2af5"
    sha256 x86_64_linux:      "cc6109ceb473994dd891c790512f357ec90b81e6d7a3aff2fcae7fe1459988db"
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
