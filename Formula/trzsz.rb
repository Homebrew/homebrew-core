class Trzsz < Formula
  include Language::Python::Virtualenv

  desc "Simple file transfer tools, similar to lrzsz (rz/sz), and compatible with tmux"
  homepage "https://trzsz.github.io"
  url "https://files.pythonhosted.org/packages/f1/db/5a3782ed49207a31f7c6e7568e0d41bbb00bbbd0eaae2f090eadff5e6244/trzsz-1.0.0.tar.gz"
  sha256 "04b3c9ee1801c382c289a7adc35c2bb0651450db80ce408219f01204a9eab4ca"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4fabbb45b21f4bdb4e857aecbefd3533d250e7f9a2f718ff8be5038b4cadf4eb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5a0147b5808b57ae58a8825ef1165bebb0633be3e96881f89102d3f9da1d825f"
    sha256 cellar: :any_skip_relocation, monterey:       "d213bd1566ce88c1a91d5ee5ebb9baa107485e56658be2da5f44b4de67ce7dee"
    sha256 cellar: :any_skip_relocation, big_sur:        "75e49fe3c8af63a00123eb819110327a3ca93409cb1b24010c675b3f32e85e09"
    sha256 cellar: :any_skip_relocation, catalina:       "2ed1f140d172d38a299593c4aefbdc662109b81452cb039648f47cb0c2aee65f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1b2a0382e7b4944b266a01a9499c5caef929cf355138374db38ee698c87f2ce6"
  end

  depends_on "protobuf"
  depends_on "python@3.10"

  resource "iterm2" do
    url "https://files.pythonhosted.org/packages/09/e7/d9a1b01cc278ba685ab5b741278ebed3205107e9cc35f66c29ef8e2b3407/iterm2-2.0.tar.gz"
    sha256 "dbe4b6a484fa5bba93a68ecd7a0c8b179bb52c0ba5bcdd96a0dd712b79ae554e"
  end

  resource "trzsz-iterm2" do
    url "https://files.pythonhosted.org/packages/67/75/32d49cec28fbca5777cd0d96c3721af73b9e101b7c5cc1c8da3868d271b9/trzsz-iterm2-1.0.0.tar.gz"
    sha256 "f6d12d3cff9efac5a5f9e99a4732a17d4828bea88584af8d1d5c70e671751d4f"
  end

  resource "trzsz-libs" do
    url "https://files.pythonhosted.org/packages/89/a0/f3d058a29fcbd7e1dbdd29f06c0c06e2daa7c2903800fd0333ad2ff66c00/trzsz-libs-1.0.0.tar.gz"
    sha256 "b6865424c95a2024d298017145bfba3a154ffd42e76d7ad746fb9eb6b9b7429a"
  end

  resource "trzsz-svr" do
    url "https://files.pythonhosted.org/packages/3f/8a/72a3acbdcbaba0a51c27fbc42cdfb5d125070186e37cf6c9bf39ac5de34a/trzsz-svr-1.0.0.tar.gz"
    sha256 "1ea84d37e50d8afb2bd8a300b9c0fd26b496e8b3b919494f890a9e2cce3c1b73"
  end

  resource "websockets" do
    url "https://files.pythonhosted.org/packages/b4/7b/0960d02701f783bb052ec69ea32789d878d2cce05a03950adbd75f164758/websockets-10.2.tar.gz"
    sha256 "8351c3c86b08156337b0e4ece0e3c5ec3e01fcd14e8950996832a23c99416098"
  end

  def install
    virtualenv_install_with_resources
    bin.install_symlink libexec/"bin/trz"
    bin.install_symlink libexec/"bin/tsz"
    bin.install_symlink libexec/"bin/trzsz-iterm2"
  end

  test do
    assert_match "trz (trzsz)", shell_output("#{bin}/trz -v")
    assert_match "tsz (trzsz)", shell_output("#{bin}/tsz -v")
    assert_match "trzsz-iterm2 (trzsz)", shell_output("#{bin}/trzsz-iterm2 -v")

    touch "tmpfile"
    assert_match "Not a directory", shell_output("#{bin}/trz tmpfile 2>&1")

    rm "tmpfile"
    assert_match "No such file", shell_output("#{bin}/tsz tmpfile 2>&1")

    assert_match "arguments are required", shell_output("#{bin}/trzsz-iterm2 2>&1", 2)
  end
end
