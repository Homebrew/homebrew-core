class Trzsz < Formula
  include Language::Python::Virtualenv

  desc "Simple file transfer tools, similar to lrzsz (rz/sz), and compatible with tmux"
  homepage "https://trzsz.github.io"
  url "https://files.pythonhosted.org/packages/22/1e/40a495c84a0dc625a4d97638c5cae308306718c493f480ee5ac64801947b/trzsz-1.1.5.tar.gz"
  sha256 "57be064b259d57326f75683704b8e93a56ce0d67d9b3b2b36ad4d53e98a28854"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6a61d3082420bad36e6cc3ce0cbffc4c87b4676b1a822c47ea901a8794c8cd3f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1f4327fbcc191a759c32c8511f231a82006d406ad2d24f5da3ebfbf7eaa85975"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "838a446dda952d38a0def33a461fab42d525bbe65ccad6459189b19056c1bea0"
    sha256 cellar: :any_skip_relocation, sonoma:         "15ce2195a334629b16820aba5db6fcfaabe0d84c05e2fb63b324783065d82015"
    sha256 cellar: :any_skip_relocation, ventura:        "dab3513ad785df333ec7cf0cd7f104443256d35c30a1e398a169459c46aa5e0c"
    sha256 cellar: :any_skip_relocation, monterey:       "5e469f50bc197b9ac948270f64aaef62fd07d49cdf87a22c7ba452fdab9661cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f64211664956cc18313872bc9e9b8eb8ad8b1974f80f3dfb2ab856be6ff4b25e"
  end

  depends_on "python@3.12"

  resource "iterm2" do
    url "https://files.pythonhosted.org/packages/4f/eb/47bb125fd3b32969f3bc8e0b8997bbe308484ac4d04331ae1e6199ae2c0f/iterm2-2.7.tar.gz"
    sha256 "f6f0bec46c32cecaf7be7fd82296ec4697d4bf2101f0c4aab24cc123991fa230"
  end

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/ea/ab/ae590cd71f5a50cd9e0979593e217529b532a001e46c2dd0811c8697f4ad/protobuf-5.26.0.tar.gz"
    sha256 "82f5870d74c99addfe4152777bdf8168244b9cf0ac65f8eccf045ddfa9d80d9b"
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
    url "https://files.pythonhosted.org/packages/2e/62/7a7874b7285413c954a4cca3c11fd851f11b2fe5b4ae2d9bee4f6d9bdb10/websockets-12.0.tar.gz"
    sha256 "81df9cbcbb6c260de1e007e58c011bfebe2dafc8435107b0537f393dd38c8b1b"
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
