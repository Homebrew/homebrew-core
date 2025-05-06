class Ramalama < Formula
  include Language::Python::Virtualenv

  desc "Goal of RamaLama is to make working with AI boring"
  homepage "https://github.com/containers/ramalama"
  url "https://files.pythonhosted.org/packages/40/05/2b6088c894e37ca4215e93e41219348678f850331be3a2843cd4baefa5d3/ramalama-0.8.2.tar.gz"
  sha256 "21e1feb44f62d9a2bcc600f2ab71477966fa70d5797fee17c011edf08cae06ec"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "046d79ee163ab2a551cb24586ee1a5e4dbeb5f72e64b38d0b9e03a60baac19b2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "046d79ee163ab2a551cb24586ee1a5e4dbeb5f72e64b38d0b9e03a60baac19b2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "046d79ee163ab2a551cb24586ee1a5e4dbeb5f72e64b38d0b9e03a60baac19b2"
    sha256 cellar: :any_skip_relocation, sonoma:        "6e0e4c1ac15c72e838b6dff204061dbb64df2e175f8c8aba59de3aa5df83b33f"
    sha256 cellar: :any_skip_relocation, ventura:       "6e0e4c1ac15c72e838b6dff204061dbb64df2e175f8c8aba59de3aa5df83b33f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "63a8b35b92840deea8e310a94b607108556492051208c0b509b5823026ab69bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "63a8b35b92840deea8e310a94b607108556492051208c0b509b5823026ab69bb"
  end

  depends_on "llama.cpp"
  depends_on "python@3.13"

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/16/0f/861e168fc813c56a78b35f3c30d91c6757d1fd185af1110f1aec784b35d0/argcomplete-3.6.2.tar.gz"
    sha256 "d0519b1bc867f5f4f4713c41ad0aba73a4a5f007449716b16f385f2166dc6adf"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "invalidllm:latest was not found", shell_output("#{bin}/ramalama run invalidllm 2>&1", 1)

    system bin/"ramalama", "pull", "tinyllama"
    list_output = shell_output("#{bin}/ramalama list")
    assert_match "tinyllama", list_output

    inspect_output = shell_output("#{bin}/ramalama inspect tinyllama")
    assert_match "Format: GGUF", inspect_output

    assert_match version.to_s, shell_output("#{bin}/ramalama version")
  end
end
