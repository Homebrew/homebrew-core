class Ramalama < Formula
  include Language::Python::Virtualenv

  desc "Goal of RamaLama is to make working with AI boring"
  homepage "https://github.com/containers/ramalama"
  url "https://files.pythonhosted.org/packages/ff/d9/ccd94fabde435a22815485e68d1800bd74b57ccda51cab6528930651bca5/ramalama-0.12.2.tar.gz"
  sha256 "a1eabbb03e2d5f926a3dfef953fcaaedbc13b58002cda81306b0f9fd1558d915"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "54b6c5e1c7f4c5e32ca5a1e4e93c893cfdcbb3f669fe27cf5a77aa4cfe673e71"
    sha256 cellar: :any,                 arm64_sequoia: "8cd0bcca6f9672dacdfb536d7c6261bc72f67d66d3abbe6e7e870aaec5029dec"
    sha256 cellar: :any,                 arm64_sonoma:  "83223d1e70d7a781d2693d25895b3ed88713cf15d3221e723e7680499955bb90"
    sha256 cellar: :any,                 arm64_ventura: "efeb0c94f1ae66d3b0e7aabaecf7ada095ddbca87d3ae0f316427ef4910ee9a7"
    sha256 cellar: :any,                 sonoma:        "993ec5113ca4533951a38b2da583b628d86d48d1e46e0f626c2a910236e3e374"
    sha256 cellar: :any,                 ventura:       "c43bee4b0deae819d1975ce196d81d6504d6d691b8b1768ca13b1961194dba84"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "93bfd367b056687762dff895d86c41b16e501e6a7e3742b0dfdaab2a7b69e137"
  end

  depends_on "libyaml"
  depends_on "llama.cpp"
  depends_on "python@3.13"

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/16/0f/861e168fc813c56a78b35f3c30d91c6757d1fd185af1110f1aec784b35d0/argcomplete-3.6.2.tar.gz"
    sha256 "d0519b1bc867f5f4f4713c41ad0aba73a4a5f007449716b16f385f2166dc6adf"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"ramalama", "pull", "tinyllama"
    list_output = shell_output("#{bin}/ramalama list")
    assert_match "TinyLlama", list_output

    inspect_output = shell_output("#{bin}/ramalama inspect tinyllama")
    assert_match "Format: GGUF", inspect_output

    assert_match version.to_s, shell_output("#{bin}/ramalama version")
  end
end
