class Sqlfluff < Formula
  include Language::Python::Virtualenv

  desc "SQL linter and auto-formatter for Humans"
  homepage "https://docs.sqlfluff.com/"
  url "https://files.pythonhosted.org/packages/06/92/38cbdd9f6be7dfd2ee14aa2152f30baaadd67c6eb0c87f03ecee9b54eb5d/sqlfluff-3.2.3.tar.gz"
  sha256 "13c56ca0175808eaee183d2224ac863ee17113808890603c52d8fffcd1e069fe"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "541ea51651f57fd8dfb4f9b86e17bb4bbe55c85e036b714e111996577203991f"
    sha256 cellar: :any,                 arm64_sonoma:  "08bd4b44659d4f4a1bb6e1d252158f9110e6aa0d6f598eb5d6394d0774917dd5"
    sha256 cellar: :any,                 arm64_ventura: "5819a52f2c2bb3200ecaeac4ac164aacf5d6e91d3b5268454787d9659ed2cf4e"
    sha256 cellar: :any,                 sonoma:        "729eb196658909adff0bf9c7442caf7e8325b34fde97448152dc2a9f04ccc9ca"
    sha256 cellar: :any,                 ventura:       "a24b40979ec10fcc9e2c36b0a8a0266e493aaca26ecc3783ada016f35e53be40"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ec820e2e1920a9012de8ec013538aec7309d57cdbe73e033c388214365432794"
  end

  depends_on "libyaml"
  depends_on "python@3.13"

  resource "appdirs" do
    url "https://files.pythonhosted.org/packages/d7/d8/05696357e0311f5b5c316d7b95f46c669dd9c15aaeecbb48c7d0aeb88c40/appdirs-1.4.4.tar.gz"
    sha256 "7d5d0167b2b1ba821647616af46a749d1c653740dd0d2415100fe26e27afdf41"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/f3/0d/f7b6ab21ec75897ed80c17d79b15951a719226b9fababf1e40ea74d69079/chardet-5.2.0.tar.gz"
    sha256 "1b3b6ff479a8c414bc3fa2c0852995695c4a026dcd6d0633b2dd092ca39c1cf7"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "diff-cover" do
    url "https://files.pythonhosted.org/packages/44/3a/e49ccba052a4dda264fbad4f467739ecc63498f7223bfc03d4bfac23ea95/diff_cover-9.2.0.tar.gz"
    sha256 "85a0b353ebbb678f9e87ea303f75b545bd0baca38f563219bb72f2ae862bba36"
  end

  resource "iniconfig" do
    url "https://files.pythonhosted.org/packages/d7/4b/cbd8e699e64a6f16ca3a8220661b5f83792b3017d0f79807cb8708d33913/iniconfig-2.0.0.tar.gz"
    sha256 "2d91e135bf72d31a410b17c16da610a82cb55f6b0477d1a902134b24a455b8b3"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/ed/55/39036716d19cab0747a5020fc7e907f362fbf48c984b14e62127f7e68e5d/jinja2-3.1.4.tar.gz"
    sha256 "4a3aee7acbbe7303aede8e9648d13b8bf88a429282aa6122a993f0ac800cb369"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/b4/d2/38ff920762f2247c3af5cbbbbc40756f575d9692d381d7c520f45deb9b8f/markupsafe-3.0.1.tar.gz"
    sha256 "3e683ee4f5d0fa2dde4db77ed8dd8a876686e3fc417655c2ece9a90576905344"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/51/65/50db4dda066951078f0a96cf12f4b9ada6e4b811516bf0262c0f4f7064d4/packaging-24.1.tar.gz"
    sha256 "026ed72c8ed3fcce5bf8950572258698927fd1dbda10a5e981cdf0ac37f4f002"
  end

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/ca/bc/f35b8446f4531a7cb215605d100cd88b7ac6f44ab3fc94870c120ab3adbf/pathspec-0.12.1.tar.gz"
    sha256 "a482d51503a1ab33b1c67a6c3813a26953dbdc71c31dacaef9a838c4e29f5712"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/96/2d/02d4312c973c6050a18b314a5ad0b3210edb65a906f868e31c111dede4a6/pluggy-1.5.0.tar.gz"
    sha256 "2cffa88e94fdc978c4c574f15f9e59b7f4201d439195c3715ca9e2486f1d0cf1"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/8e/62/8336eff65bcbc8e4cb5d05b55faf041285951b6e80f33e2bff2024788f31/pygments-2.18.0.tar.gz"
    sha256 "786ff802f32e91311bff3889f6e9a86e81505fe99f2735bb6d60ae0c5004f199"
  end

  resource "pytest" do
    url "https://files.pythonhosted.org/packages/8b/6c/62bbd536103af674e227c41a8f3dcd022d591f6eed5facb5a0f31ee33bbc/pytest-8.3.3.tar.gz"
    sha256 "70b98107bd648308a7952b06e6ca9a50bc660be218d53c257cc1fc94fda10181"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/f9/38/148df33b4dbca3bd069b963acab5e0fa1a9dbd6820f8c322d0dd6faeff96/regex-2024.9.11.tar.gz"
    sha256 "6c188c307e8433bcb63dc1915022deb553b4203a70722fc542c363bf120a01fd"
  end

  resource "tblib" do
    url "https://files.pythonhosted.org/packages/1a/df/4f2cd7eaa6d41a7994d46527349569d46e34d9cdd07590b5c5b0dcf53de3/tblib-3.0.0.tar.gz"
    sha256 "93622790a0a29e04f0346458face1e144dc4d32f493714c6c3dff82a4adb77e6"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/58/83/6ba9844a41128c62e810fddddd72473201f3eacde02046066142a2d96cc5/tqdm-4.66.5.tar.gz"
    sha256 "e1020aef2e5096702d8a025ac7d16b1577279c9d63f8375b63083e9a5f0fcbad"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"sqlfluff", shells: [:fish, :zsh], shell_parameter_format: :click)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sqlfluff --version")
    (testpath/"test.sql").write <<~EOS
      SELECT 1;
    EOS
    assert_match "All Finished!", shell_output("#{bin}/sqlfluff lint --dialect sqlite --nocolor #{testpath}/test.sql")
  end
end
