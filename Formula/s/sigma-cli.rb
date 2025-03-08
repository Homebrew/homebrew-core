class SigmaCli < Formula
  include Language::Python::Virtualenv

  desc "CLI based on pySigma"
  homepage "https://github.com/SigmaHQ/sigma-cli"
  url "https://files.pythonhosted.org/packages/7e/9a/6ad847f2e2ad0ac673839504a9aa1bf1b69f2c38265cf119a8b3d3dbf481/sigma_cli-1.0.5.tar.gz"
  sha256 "7720244026fabf5bbd1ba37ae67b9cc1dc9d61a79320562d55e2228409b159e7"
  license "LGPL-2.1-or-later"
  revision 1
  head "https://github.com/SigmaHQ/sigma-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "4e5a5e2500a78686eb148ad2ec997f4b99093503b5efdc4b04127aaa0392b237"
    sha256 cellar: :any,                 arm64_sonoma:  "6f5bc461b76f4c1960482d648e708839464a7c6b6a8dff911f4fb4365d5cb236"
    sha256 cellar: :any,                 arm64_ventura: "8c884e0e252c3c76ea47a893de6689dd776913f9076875ccbf75b0e2dc23af70"
    sha256 cellar: :any,                 sonoma:        "02a0c87e8d0b6b34c392a38d4f978818522f9ec3d4641cafaf6e0a174a8e85a5"
    sha256 cellar: :any,                 ventura:       "d5dd6070e60661bd85e93b04ef7276d890e3cd826a11c8f6df66a178fc1e4cdd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "85b48f3544a8b9111dc264ebfa6ebe09890fc1e7fe755a47b96b24c5acd1a6d9"
  end

  depends_on "certifi"
  depends_on "libyaml"
  depends_on "python@3.13"

  conflicts_with "open-simh", because: "both install `sigma` binaries"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/16/b0/572805e227f01586461c80e0fd25d65a2115599cc9dad142fee4b747c357/charset_normalizer-3.4.1.tar.gz"
    sha256 "44251f18cd68a75b56585dd00dae26183e102cd5e0f9f1466e6df5da2ed64ea3"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/b9/2e/0090cbf739cee7d23781ad4b89a9894a41538e4fcf4c31dcdd705b78eb8b/click-8.1.8.tar.gz"
    sha256 "ed53c9d8990d83c2a27deae68e4ee337473f6330c040a31d4225c9574d16096a"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f1/70/7703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7d/idna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/b2/97/5d42485e71dfc078108a86d6de8fa46db44a1a9295e89c5d6d4a06e23a62/markupsafe-3.0.2.tar.gz"
    sha256 "ee55d3edf80167e48ea11a923c7386f4669df67d7994554387f84e7d8b0a2bf0"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/d0/63/68dbb6eb2de9cb10ee4c9c14a0148804425e13c4fb20d61cce69f53106da/packaging-24.2.tar.gz"
    sha256 "c228a6dc5e932d346bc5739379109d49e8853dd8223571c7c5b55260edc0b97f"
  end

  resource "prettytable" do
    url "https://files.pythonhosted.org/packages/38/95/78080e58efbdde46cda8d4498737bf9687839ed4a9744b068cc730a073ed/prettytable-3.15.1.tar.gz"
    sha256 "f0edb38060cb9161b2417939bfd5cd9877da73388fb19d1e8bf7987e8558896e"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/8b/1a/3544f4f299a47911c2ab3710f534e52fea62a633c96806995da5d25be4b2/pyparsing-3.2.1.tar.gz"
    sha256 "61980854fd66de3a90028d679a954d5f2623e83144b5afe5ee86f43d762e5f0a"
  end

  resource "pysigma" do
    url "https://files.pythonhosted.org/packages/4c/e8/88fe64e0ff626362a366dddb5ba8229b087aec5b0fae5ec76ad5988830a0/pysigma-0.11.19.tar.gz"
    sha256 "075df35e56f2128491f8ad501cc063d88d282879d37b50213fc6b5008fac8625"

    # poetry 2.0 build patch, upstream pr ref, https://github.com/SigmaHQ/pySigma/pull/318
    patch do
      url "https://github.com/Homebrew/formula-patches/commit/d0361c3e94fd7020a2f94d0c2e1124a9371134e5.patch?full_index=1"
      sha256 "bd6e4fb6d4d214a469902e350d7d9429ae44ee55cf1d43ba36085d17cd5824d3"
    end
  end

  resource "pysigma-backend-sqlite" do
    url "https://files.pythonhosted.org/packages/72/63/e618d84f770f982afa5f8e99a93c99c48bd87992d1ba4cc961aab6ba15e9/pysigma_backend_sqlite-0.2.0.tar.gz"
    sha256 "0ff1bbb0165477e938e2951808ba348bd29803fd3fae5c4cbcd117532e622217"

    # poetry 2.0 build patch, upstream pr ref, https://github.com/SigmaHQ/pySigma-backend-sqlite/pull/6
    patch do
      url "https://github.com/SigmaHQ/pySigma-backend-sqlite/commit/865350ce1a398acd7182f6f8429c3048db54ef1d.patch?full_index=1"
      sha256 "aff54090de9eecf5e5c0d69abd3be294ca86eba6b2e58d0c574528bd6058bfc4"
    end
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/63/70/2bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913/requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/aa/63/e53da845320b757bf29ef6a9062f5c669fe997973f966045cb019c3f4b66/urllib3-2.3.0.tar.gz"
    sha256 "f8c5449b3cf0861679ce7e0503c7b44b5ec981bec0d1d3795a07f1ba96f0204d"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/6c/63/53559446a878410fc5a5974feb13d31d78d752eb18aeba59c7fef1af7598/wcwidth-0.2.13.tar.gz"
    sha256 "72ea0c06399eb286d978fdedb6923a9eb47e1c486ce63e9b4e64fc18303972b5"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"sigma", shells: [:fish, :zsh], shell_parameter_format: :click)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sigma version")

    output = shell_output("#{bin}/sigma plugin list")
    assert_match "SQLite and Zircolite backend", output

    # Only show compatible plugins
    output = shell_output("#{bin}/sigma plugin list --compatible")
    refute_match "IBM QRadar backend", output
  end
end
