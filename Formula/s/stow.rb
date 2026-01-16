class Stow < Formula
  desc "Organize software neatly under a single directory tree (e.g. /usr/local)"
  homepage "https://www.gnu.org/software/stow/"
  url "https://ftpmirror.gnu.org/gnu/stow/stow-2.4.1.tar.gz"
  mirror "https://ftp.gnu.org/gnu/stow/stow-2.4.1.tar.gz"
  sha256 "2a671e75fc207303bfe86a9a7223169c7669df0a8108ebdf1a7fe8cd2b88780b"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "74d7b0d6d849528a320c63802f21390c65a700a28295f546be29d5b87d78b25f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "d4c48d441c3aec3763807b9937c6f8e0aa118fd3e8726f4419ffe3928a4f4ae0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d4c48d441c3aec3763807b9937c6f8e0aa118fd3e8726f4419ffe3928a4f4ae0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "22e553b127f24001900605515df147dff27f5eb0b99805d63de1bcffb1c5a0d3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "22e553b127f24001900605515df147dff27f5eb0b99805d63de1bcffb1c5a0d3"
    sha256 cellar: :any_skip_relocation, sonoma:         "4829b15c46ae06aebd28e6ca0148f7b743de698041f4f8dd1c88b8e1e2fb7f1b"
    sha256 cellar: :any_skip_relocation, ventura:        "50ca7991910a8b752ee6d5504f8cab1e2012de4759d517c68e1389f42c952242"
    sha256 cellar: :any_skip_relocation, monterey:       "50ca7991910a8b752ee6d5504f8cab1e2012de4759d517c68e1389f42c952242"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "d0c8d1eb137984030db04350a3efc522c26a486be22f6e940dbcd0f30927edf9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "99e225c98e4bbc9dfaa3a6dfbeea16b9e2f91bacc18801212902fbb81962f73a"
  end

  uses_from_macos "perl"

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test").mkpath
    system bin/"stow", "-nvS", "test"
  end
end
