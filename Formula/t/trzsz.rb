class Trzsz < Formula
  include Language::Python::Virtualenv

  desc "Simple file transfer tools, similar to lrzsz (rz/sz), and compatible with tmux"
  homepage "https://trzsz.github.io"
  url "https://files.pythonhosted.org/packages/22/1e/40a495c84a0dc625a4d97638c5cae308306718c493f480ee5ac64801947b/trzsz-1.1.5.tar.gz"
  sha256 "57be064b259d57326f75683704b8e93a56ce0d67d9b3b2b36ad4d53e98a28854"
  license "MIT"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b57f72d47439cd304aa457bcd75e138d447b4819571c9a01fac3e8856b7d832a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8ce638b0601b5f449a00264cd0de40f0167fd485108d321c64eebc8ccb4c0bb7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2c9385e793d458298fe55e9ce4f0d80c1ab0d78a28fa468d03a94ecc8dbb47b2"
    sha256 cellar: :any_skip_relocation, sonoma:        "c7551b00282c2c5e16a00d56bd961ab504f38a605d5d1e2a6012a7d10dc27492"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ffe42aec52133ecfdb2fbae429d43c8042789d80125e5e6890ab65362365e6ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a212e8abf46f7833d81f32028d3552df8ca793366e4743219ede67442c4d94f3"
  end

  depends_on "python@3.14"

  conflicts_with "trzsz-go", because: "both install `trz`, `tsz` binaries"

  pypi_packages extra_packages: "trzsz-iterm2"

  resource "iterm2" do
    url "https://files.pythonhosted.org/packages/57/6b/98ce521178651fad694c7ed704c882e4ef0b10fecc0a687b4e859ef623c3/iterm2-2.10.tar.gz"
    sha256 "8c0cf95ffca9f1bf7409883618deee66acd73c63929222e23435780dcc516869"
  end

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/fa/a4/cc17347aa2897568beece2e674674359f911d6fe21b0b8d6268cd42727ac/protobuf-6.32.1.tar.gz"
    sha256 "ee2469e4a021474ab9baafea6cd070e5bf27c7d29433504ddea1a4ee5850f68d"
  end

  resource "trzsz-iterm2" do
    url "https://files.pythonhosted.org/packages/1e/21/e8c12001396080263407277edc85ba765ee18bed54ae6d72e83516de7d9c/trzsz-iterm2-1.1.5.tar.gz"
    sha256 "a7f6fb6359523d871d03be099a876043d039458cb6086d22d1e0f3e874283c4b"
  end

  resource "trzsz-libs" do
    url "https://files.pythonhosted.org/packages/f2/c2/89cfeb038585c18e320ede2182d70096a162f22298e29b7f1234bbc5230e/trzsz-libs-1.1.5.tar.gz"
    sha256 "baff5cea450e1310a292f5702d4a8f7dc855fbe2aefe21b13d2451bc05cedea4"
  end

  resource "trzsz-svr" do
    url "https://files.pythonhosted.org/packages/76/c7/78c1c91eeb99c86dd80d903cdb463da0d1fbea9b7f25a1c1de5b0f96ecf5/trzsz-svr-1.1.5.tar.gz"
    sha256 "2f1fbc119df3c6010bf7b030635a5dc3cc1513025e5d0415d84d2d2a417b077f"
  end

  resource "websockets" do
    url "https://files.pythonhosted.org/packages/21/e6/26d09fab466b7ca9c7737474c52be4f76a40301b08362eb2dbc19dcc16c1/websockets-15.0.1.tar.gz"
    sha256 "82544de02076bafba038ce055ee6412d68da13ab47f0c60cab827346de828dee"
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
