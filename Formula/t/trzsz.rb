class Trzsz < Formula
  include Language::Python::Virtualenv

  desc "Simple file transfer tools, similar to lrzsz (rz/sz), and compatible with tmux"
  homepage "https://trzsz.github.io"
  url "https://files.pythonhosted.org/packages/22/1e/40a495c84a0dc625a4d97638c5cae308306718c493f480ee5ac64801947b/trzsz-1.1.5.tar.gz"
  sha256 "57be064b259d57326f75683704b8e93a56ce0d67d9b3b2b36ad4d53e98a28854"
  license "MIT"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "069b5e2e21ca4ee881b66892d88f678d5239cd0d17de98560b483bdc4e361e97"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "34b1462777caa9dad8e2b457f0ac821c3fd74dff173f32f6d6dca728b4123cdf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "327fbdc12feae3e8d94c081d2918e5ac31bbe85d9d894106ef59b43ffec19cdd"
    sha256 cellar: :any_skip_relocation, sonoma:        "cb036cbea4083fda7d9169854ba154c8aa7c09593cb46935c9a5d93190fe3af4"
    sha256 cellar: :any_skip_relocation, ventura:       "d23b42eed99c1ff1ff1ef5ee4bb9a5e093d60f3680ac2e6bf834559b8cc8309c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9352e42e41666d7842af49aa3100bc328c44c384e3b4689c35e7391438c4a7b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4fb0a8bab1c0def85b2e0d11e37d9e96d1c397485b5231fe9d3f952a6e5f9fe4"
  end

  depends_on "python@3.13"

  conflicts_with "trzsz-go", because: "both install `trz`, `tsz` binaries"

  resource "iterm2" do
    url "https://files.pythonhosted.org/packages/87/a6/7c6e0836e83d67eafd2e92dc5449fc2b3fc715bc8cdd4391cd3178aaa937/iterm2-2.8.tar.gz"
    sha256 "90d3e86d6af5d955c319993c8352cf3e93c7a0c919ed8b2ad551a742b87e889b"
  end

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/b1/a4/4579a61de526e19005ceeb93e478b61d77aa38c8a85ad958ff16a9906549/protobuf-5.28.2.tar.gz"
    sha256 "59379674ff119717404f7454647913787034f03fe7049cbef1d74a97bb4593f0"
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
    url "https://files.pythonhosted.org/packages/e2/73/9223dbc7be3dcaf2a7bbf756c351ec8da04b1fa573edaf545b95f6b0c7fd/websockets-13.1.tar.gz"
    sha256 "a3b3366087c1bc0a2795111edcadddb8b3b59509d5db5d7ea3fdd69f954a8878"
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
