class Xonsh < Formula
  include Language::Python::Virtualenv

  desc "Python-powered, cross-platform, Unix-gazing shell language and command prompt"
  homepage "https://xon.sh/"
  url "https://files.pythonhosted.org/packages/98/6e/b54a0b2685535995ee50f655103c463f9d339455c9b08c4bce3e03e7bb17/xonsh-0.19.1.tar.gz"
  sha256 "5d3de649c909f6d14bc69232219bcbdb8152c830e91ddf17ad169c672397fb97"
  license "BSD-2-Clause-Views"
  head "https://github.com/xonsh/xonsh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "119ca35d3aee96cf2a4758a4bf8c0c01360f44774c10a8c486fcc6f79772e6b9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0aa888f2bf2b2af2ff5c580786258ee00ae0d30e1705d9edf397e1b2deaa6578"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ad92c6c5286aebafe55a5d7e057a1341d8f189d601b6e9e1fc232fa1fba3a69b"
    sha256 cellar: :any_skip_relocation, sonoma:        "52134dca9948aceb0c4a17d665ad3da835a1036718795122450dabb99b7f7b34"
    sha256 cellar: :any_skip_relocation, ventura:       "b9381133b9b1dce6cc0fb16e6940c3e2137ebc7b07719506367b41e2fd0a93a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2f8ffb0ec3a0fbf090a6991a95951e494129d7dee8cd296221816b2462e4e379"
  end

  depends_on "python@3.13"

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/2d/4f/feb5e137aff82f7c7f3248267b97451da3644f6cdc218edfe549fb354127/prompt_toolkit-3.0.48.tar.gz"
    sha256 "d6623ab0477a80df74e646bdbc93621143f5caf104206aa29294d53de1a03d90"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/7c/2d/c3338d48ea6cc0feb8446d8e6937e1408088a72a39937982cc6111d17f84/pygments-2.19.1.tar.gz"
    sha256 "61c16d2a8576dc0649d9f39e089b5f02bcd27fba10d8fb4dcc28173f7a45151f"
  end

  resource "pyperclip" do
    url "https://files.pythonhosted.org/packages/30/23/2f0a3efc4d6a32f3b63cdff36cd398d9701d26cda58e3ab97ac79fb5e60d/pyperclip-1.9.0.tar.gz"
    sha256 "b7de0142ddc81bfc5c7507eea19da920b92252b548b96186caf94a5e2527d310"
  end

  resource "setproctitle" do
    url "https://files.pythonhosted.org/packages/ae/4e/b09341b19b9ceb8b4c67298ab4a08ef7a4abdd3016c7bb152e9b6379031d/setproctitle-1.3.4.tar.gz"
    sha256 "3b40d32a3e1f04e94231ed6dfee0da9e43b4f9c6b5450d53e6dd7754c34e0c50"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/6c/63/53559446a878410fc5a5974feb13d31d78d752eb18aeba59c7fef1af7598/wcwidth-0.2.13.tar.gz"
    sha256 "72ea0c06399eb286d978fdedb6923a9eb47e1c486ce63e9b4e64fc18303972b5"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "4", shell_output("#{bin}/xonsh -c 2+2")
  end
end
