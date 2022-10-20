class Trzsz < Formula
  include Language::Python::Virtualenv

  desc "Simple file transfer tools, similar to lrzsz (rz/sz), and compatible with tmux"
  homepage "https://trzsz.github.io"
  url "https://files.pythonhosted.org/packages/1a/73/dfeb828f96ce7a395fe38ce72f29b0e7fe3c43348f946ca7d3806a79e1a0/trzsz-1.1.0.tar.gz"
  sha256 "4e0d1b8afb8912d351e0de997f8f1e557298b547a6daac03c6a60282962ada72"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5a33d8e1027e2dcc3b66748bcccd26fafbbd76164bbb0e6fdf5e039b5b253054"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3a7255468430adc1e9cdbd52692dcb932d56dea831cffc32f7e3201bb8a73560"
    sha256 cellar: :any_skip_relocation, monterey:       "ad3127d4f5594fcc8d9fe674802415908051747281d953499ba70f49a5e7ec69"
    sha256 cellar: :any_skip_relocation, big_sur:        "d74a257f520b8303bfd38cceb311c329d644bd9c2e2b9989b32fdc02727bf6ba"
    sha256 cellar: :any_skip_relocation, catalina:       "0429ec0db1f6a8fb61f84005c3750d2f5745576fcec3c6ff9525667888bec8a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "476a4150a84b1a7190bb283e13a9b12274dbd8c616327d452ce17364a03c544a"
  end

  depends_on "protobuf"
  depends_on "python@3.10"

  resource "iterm2" do
    url "https://files.pythonhosted.org/packages/37/a9/0f01cd95cd099a04b221a817f3b01d17034a1de6d4c3319f66ef09822b08/iterm2-2.5.tar.gz"
    sha256 "4e0f8a463fd4d6be1282fdd12df0e17e876782ae96a45b8afd508ffd22f58555"
  end

  resource "trzsz-iterm2" do
    url "https://files.pythonhosted.org/packages/9a/26/6f8505a1908efde7b771ba365beaf7c627fcb96e27691d380d9dc0272b72/trzsz-iterm2-1.1.0.tar.gz"
    sha256 "89f37b641528893ce529adf02e754f6d083379d4c9016590669f329b754f0966"
  end

  resource "trzsz-libs" do
    url "https://files.pythonhosted.org/packages/3f/75/c52618d862018af7ca1923be2b63d2cf7845f69da38970088fd64bb071e5/trzsz-libs-1.1.0.tar.gz"
    sha256 "f116a18d6429be74ff6a321e9a6b0b59afecc5d62bf27c9f17bd63a39b31633c"
  end

  resource "trzsz-svr" do
    url "https://files.pythonhosted.org/packages/eb/82/39f3144bd3584f7ecc5f23fa5f929d5cba8135ec690bfcbceae02490448f/trzsz-svr-1.1.0.tar.gz"
    sha256 "057ba12437f72e92b95087d6699ba9849d6f1a41286d9e9c7539a603d22a22fc"
  end

  resource "websockets" do
    url "https://files.pythonhosted.org/packages/f8/a3/622d9acbfb9a71144b5d7609906bc648c62e3ca5fdbb1c8cca222949d82c/websockets-10.3.tar.gz"
    sha256 "fc06cc8073c8e87072138ba1e431300e2d408f054b27047d047b549455066ff4"
  end

  def install
    virtualenv_install_with_resources
    bin.install_symlink libexec/"bin/trz"
    bin.install_symlink libexec/"bin/tsz"
    bin.install_symlink libexec/"bin/trzsz-iterm2"
  end

  test do
    assert_match "trz (trzsz) py #{version}", shell_output("#{bin}/trz -v")
    assert_match "tsz (trzsz) py #{version}", shell_output("#{bin}/tsz -v")
    assert_match "trzsz-iterm2 (trzsz) py #{version}", shell_output("#{bin}/trzsz-iterm2 -v")

    touch "tmpfile"
    assert_match "Not a directory", shell_output("#{bin}/trz tmpfile 2>&1")

    rm "tmpfile"
    assert_match "No such file", shell_output("#{bin}/tsz tmpfile 2>&1")

    assert_match "arguments are required", shell_output("#{bin}/trzsz-iterm2 2>&1", 2)
  end
end
