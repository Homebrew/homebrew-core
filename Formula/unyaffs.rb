class Unyaffs < Formula
  desc "Extract files from a YAFFS2 filesystem image"
  homepage "https://packages.debian.org/sid/unyaffs"
  url "https://deb.debian.org/debian/pool/main/u/unyaffs/unyaffs_0.9.7.orig.tar.gz"
  sha256 "099ee9e51046b83fe8555d7a6284f6fe4fbae96be91404f770443d8129bd8775"
  license "GPL-2.0-only"
  revision 1

  livecheck do
    url "https://deb.debian.org/debian/pool/main/u/unyaffs/"
    regex(/href=.*?unyaffs[._-]v?(\d+(?:\.\d+)+)\.orig\.t/i)
  end

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
    man1.install "unyaffs.1"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/unyaffs -V")
  end
end
