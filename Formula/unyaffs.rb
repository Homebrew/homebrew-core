class Unyaffs < Formula
  desc "Extract files from a YAFFS2 filesystem image"
  homepage "https://www.b-ehlers.de/projects/unyaffs.html"
  url "https://git.b-ehlers.de/ehlers/unyaffs/archive/0.9.7.tar.gz"
  sha256 "792d18c3866910e25026aaa9dcfdec4b67bca7453ce5b2474d1ce8e9d31b2c69"
  license "GPL-2.0-only"
  head "https://git.b-ehlers.de/ehlers/unyaffs.git"

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d5516a71d691f78f1efb0d7f12f2a8ab2b4500ad2a9c1e1ccd5ace316111a1a1"
    sha256 cellar: :any_skip_relocation, big_sur:       "54982f10cb8c866e7370886765744c109f3566717f7af6f397e8a83a7ca65520"
    sha256 cellar: :any_skip_relocation, catalina:      "0319fb2b8ee918808e30a0bb5deef42abaf7d4afe35cff538b4ed513f06de16e"
    sha256 cellar: :any_skip_relocation, mojave:        "1c3b921af84a9fee0bb8faf7d420ff2a3d6e6a4e42aeec235d8587a8ccd5da61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e3059fb9a522e08ac50f2f45eb62e373bce28b64fb23442d9e4822aaf9d0cb37"
  end

  def install
    system "make"
    bin.install "unyaffs"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/unyaffs -V")
  end
end
