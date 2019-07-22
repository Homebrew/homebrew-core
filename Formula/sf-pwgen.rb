class SfPwgen < Formula
  desc "Generate passwords using SecurityFoundation framework"
  homepage "https://github.com/anders/pwgen/"
  url "https://github.com/anders/pwgen/archive/1.5.tar.gz"
  sha256 "e1f1d575638f216c82c2d1e9b52181d1d43fd05e7169db1d6f9f5d8a2247b475"
  head "https://github.com/anders/pwgen.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ddd6e11e839c49e2fafb3ed4c3a28b773bc1580a47a441c9ffb025b3bfa9dbd3" => :mojave
    sha256 "05ac7530759e9f2cf3a0e94a5b1f4fea83a1710de8010fa9b3d9b60167018038" => :high_sierra
    sha256 "ff59281df8d8c0e341233cdffafe67d0dc78101afb90a8597b0a83605ef578a3" => :sierra
    sha256 "2c0e0523569aa25fe254012d3b86ae0bdc587c0f17c4a62d8d12917b7fa44fbf" => :el_capitan
    sha256 "2c6d133b3c9b079dc8c81407107a3c1fb4d5cb3d654afa7acef6f23b9f9df9a6" => :yosemite
  end

  def install
    system "make"
    bin.install "sf-pwgen"
  end

  test do
    assert_equal 20, shell_output("#{bin}/sf-pwgen -a memorable -c 1 -l 20").chomp.length
  end
end
