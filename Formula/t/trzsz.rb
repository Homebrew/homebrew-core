class Trzsz < Formula
  include Language::Python::Virtualenv

  desc "Simple file transfer tools, similar to lrzsz (rz/sz), and compatible with tmux"
  homepage "https://trzsz.github.io"
  url "https://files.pythonhosted.org/packages/22/1e/40a495c84a0dc625a4d97638c5cae308306718c493f480ee5ac64801947b/trzsz-1.1.5.tar.gz"
  sha256 "57be064b259d57326f75683704b8e93a56ce0d67d9b3b2b36ad4d53e98a28854"
  license "MIT"
  revision 1

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2ae631d662b7807bc3be9aa38befc2e2659e9ce869945a911572c409329a93c0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "40a22d7d73f5af874c041823e8e26f1ddbd2e52f18067efc9fe1284af2b972f0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e3073d8234be392605f574e0242d7d6afb99da2ba75a6489e9f77f1d4dae962b"
    sha256 cellar: :any_skip_relocation, sonoma:        "a1a27587ecc16a7f5b473f5662e28359055be3a77001ac9077fd4113a19b1d8d"
    sha256 cellar: :any_skip_relocation, ventura:       "421fa223a87dfb4577ba9eac3fe88b616eaa620f4e98335aad72d1abeaf3fd02"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f7ea98196e40ccc5c7a932383bdd9851c62d55b1ec2b6a483be691804314c36c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9410ef829e189c035a0bec3e9bd8dad0ee5c106d0b3da9ae48fb8dbb7a27f820"
  end

  depends_on "python@3.13"

  conflicts_with "trzsz-go", because: "both install `trz`, `tsz` binaries"

  resource "iterm2" do
    url "https://files.pythonhosted.org/packages/57/6b/98ce521178651fad694c7ed704c882e4ef0b10fecc0a687b4e859ef623c3/iterm2-2.10.tar.gz"
    sha256 "8c0cf95ffca9f1bf7409883618deee66acd73c63929222e23435780dcc516869"
  end

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/52/f3/b9655a711b32c19720253f6f06326faf90580834e2e83f840472d752bc8b/protobuf-6.31.1.tar.gz"
    sha256 "d8cac4c982f0b957a4dc73a80e2ea24fab08e679c0de9deb835f4a12d69aca9a"
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
