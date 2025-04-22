class Ramalama < Formula
  include Language::Python::Virtualenv

  desc "Goal of RamaLama is to make working with AI boring"
  homepage "https://github.com/containers/ramalama"
  url "https://files.pythonhosted.org/packages/c3/5f/101079d8fc2ff8de8ac61892672450aab225153c340fc3c3b3b9544d52c6/ramalama-0.7.5.tar.gz"
  sha256 "5c21753c181ca831276661cba25ac51d603c374943ed48aa7e2023ce58ae9df6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "91eb19afd0ca062774f76fbd3823f575db148fcb0ce7357c06e05a633fdfab31"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "91eb19afd0ca062774f76fbd3823f575db148fcb0ce7357c06e05a633fdfab31"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "91eb19afd0ca062774f76fbd3823f575db148fcb0ce7357c06e05a633fdfab31"
    sha256 cellar: :any_skip_relocation, sonoma:        "0786e7d81d3dd6c0ffc1b9b10ae0722d3469ae85c8ce70d9d1632b493213776a"
    sha256 cellar: :any_skip_relocation, ventura:       "0786e7d81d3dd6c0ffc1b9b10ae0722d3469ae85c8ce70d9d1632b493213776a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1129de2b2a2c4971f536adf0efeb51021cedf6d607b7a0a82fa1b9eeb983c5ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1129de2b2a2c4971f536adf0efeb51021cedf6d607b7a0a82fa1b9eeb983c5ea"
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
    assert_match "invalidllm was not found", shell_output("#{bin}/ramalama run invalidllm 2>&1", 1)

    system bin/"ramalama", "pull", "tinyllama"
    list_output = shell_output("#{bin}/ramalama list")
    assert_match "tinyllama", list_output

    inspect_output = shell_output("#{bin}/ramalama inspect tinyllama")
    assert_match "Format: GGUF", inspect_output

    assert_match version.to_s, shell_output("#{bin}/ramalama version")
  end
end
