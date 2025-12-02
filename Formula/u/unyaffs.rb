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

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "5068e81bc76a677c3b186e77b91df1b38d9fd0c2936762231c1c54ccceca194a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "ec8fe9164edaf17dc336a0dc203f5955d17692fa22f508cfe04f4cd87921a85c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "992ddb8ed826d693a43e89852d2a913e79547240910233975d83660b66f88835"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "928a43f3c85d35b25a782cca819a91de0f0836745093784bac2ac71217c55ede"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6bcb9d49cf20172488361e571f7411b6db6e42e9052cf005c4035c6a223d5c0d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b70c51c64fb6a69a0b26295d8b1d444c9a1a3b69f0283449657039537074fc64"
    sha256 cellar: :any_skip_relocation, sonoma:         "88cb072ec2c01fa29325d1992f1261585079091b1641ad3258cf5b1c0276bfbe"
    sha256 cellar: :any_skip_relocation, ventura:        "641a7e133d326fcaa9d6c280e721c5a265694f086acd7a07ccebd850fe7ed652"
    sha256 cellar: :any_skip_relocation, monterey:       "1ff1b1841d784d1fccc11d986113a60bad0d61d3faf21ce8f456d8b47d00ae1b"
    sha256 cellar: :any_skip_relocation, big_sur:        "961d0e37689b4e339382d8354c452640a52df505b2466e49e99775a6870f654b"
    sha256 cellar: :any_skip_relocation, catalina:       "936d36f9cbe3df837dff0759f65c46e6083c922c1a8e7e504a6ac3b734fd3805"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "8c792cf1749a245cfabfa082c6ae0fc4ff707f65f258225d3d5d64e20b80b992"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8ea922f7eba91f9c6d6f3769fc9491e0f1414d9ecf006855414f8a544ef01638"
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
