class Trzsz < Formula
  include Language::Python::Virtualenv

  desc "Simple file transfer tools, similar to lrzsz (rz/sz), and compatible with tmux"
  homepage "https://trzsz.github.io"
  url "https://files.pythonhosted.org/packages/1a/73/dfeb828f96ce7a395fe38ce72f29b0e7fe3c43348f946ca7d3806a79e1a0/trzsz-1.1.0.tar.gz"
  sha256 "4e0d1b8afb8912d351e0de997f8f1e557298b547a6daac03c6a60282962ada72"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3f2338f18c26ef9115ad67c2338b8cd07139113e89e2a40e0eaa7b696de2b8cf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "07154f877574bbf3fee21b8e6a13358473b3bd0d0d45130924042a004a1dbd53"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8c64bd93a5b3d27d0906f0e72b0c24ab4b9376da99bd744102ee5e865523b490"
    sha256 cellar: :any_skip_relocation, monterey:       "f398dfd1819a386aba368ae0b3d9d2f8faf05a2f5534a75463588b6226106432"
    sha256 cellar: :any_skip_relocation, big_sur:        "544b91290504a9dd32eb95cd8088286fd47bbcb04cfd8ed87b2b78b73d265356"
    sha256 cellar: :any_skip_relocation, catalina:       "afc42b34487bfced6811239e7e0ba531a61b3d6a7f3871148f2216c60853f3b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "34ec912a61b25e0d9b45afa6c72af31ef3d987f9479ab134ab483314f5157549"
  end

  depends_on "protobuf"
  depends_on "python@3.11"

  resource "iterm2" do
    url "https://files.pythonhosted.org/packages/4f/eb/47bb125fd3b32969f3bc8e0b8997bbe308484ac4d04331ae1e6199ae2c0f/iterm2-2.7.tar.gz"
    sha256 "f6f0bec46c32cecaf7be7fd82296ec4697d4bf2101f0c4aab24cc123991fa230"
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
    url "https://files.pythonhosted.org/packages/85/dc/549a807a53c13fd4a8dac286f117a7a71260defea9ec0c05d6027f2ae273/websockets-10.4.tar.gz"
    sha256 "eef610b23933c54d5d921c92578ae5f89813438fded840c2e9809d378dc765d3"
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
