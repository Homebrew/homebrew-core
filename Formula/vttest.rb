class Vttest < Formula
  desc "Test compatibility of VT100-compatible terminals"
  homepage "https://invisible-island.net/vttest/"
  url "https://invisible-mirror.net/archives/vttest/vttest-20220215.tgz", using: :homebrew_curl
  sha256 "4a65998c5e12cf08ced2cfce119adb44fa842ac1495d0f150f21c8a6785915a1"
  license "BSD-3-Clause"

  livecheck do
    url "https://invisible-mirror.net/archives/vttest/"
    regex(/href=.*?vttest[._-]v?(\d+(?:[.-]\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "14aa7e91181668c8615619e9617edbfc6c12aa3d6b638ca8906af7eecf98f043"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9610ccd762ee596ec5f62ca50953ee1b73f77a7071cb1ce143b806ba04a7cd19"
    sha256 cellar: :any_skip_relocation, monterey:       "e2687d00cece7a88d635260e7085b93cfd97b4ea1bb5fb74992f8a69e72663bd"
    sha256 cellar: :any_skip_relocation, big_sur:        "4bfc9967d835e8fcdc41b321ec2f5a33d051133abe8d14c265215b79129665c9"
    sha256 cellar: :any_skip_relocation, catalina:       "36bd8eaaa5b42aad1f9a0fb53db4e9cd97e986b65630cb97b5239c1137353f23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2d6aeaa57cdbb9b878b3c85e202da9035bcc4ad94ce47c442b5dc11c0eea1bb4"
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output(bin/"vttest -V")
  end
end
