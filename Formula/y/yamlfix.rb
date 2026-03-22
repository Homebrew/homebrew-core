class Yamlfix < Formula
  include Language::Python::Virtualenv

  desc "Simple and configurable YAML formatter that keeps comments"
  homepage "https://lyz-code.github.io/yamlfix/"
  url "https://files.pythonhosted.org/packages/93/1d/b60d4411ff495de9b7598cc041e29c661e8e2f9d476a8a09bad1f54c1bce/yamlfix-1.19.1.tar.gz"
  sha256 "05f6add13959637564f278e9237f6e201ff75e061a0a4cb9fc06fa95c3001a22"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "2d045588a0278d68fc8602394f5550e848c93d1c4aa9952fb9d3cd81514bb4a4"
  end

  depends_on "pydantic" => :no_linkage
  depends_on "python@3.14"

  pypi_packages exclude_packages: "pydantic"

  resource "annotated-doc" do
    url "https://files.pythonhosted.org/packages/57/ba/046ceea27344560984e26a590f90bc7f4a75b06701f653222458922b558c/annotated_doc-0.0.4.tar.gz"
    sha256 "fbcda96e87e9c92ad167c2e53839e57503ecfda18804ea28102353485033faa4"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/3d/fa/656b739db8587d7b5dfa22e22ed02566950fbfbcdc20311993483657a5c0/click-8.3.1.tar.gz"
    sha256 "12ff4785d337a1bb490bb7e9c2b1ee5da3112e94a8622f26a6c77f5d2fc6842a"
  end

  resource "distro" do
    url "https://files.pythonhosted.org/packages/fc/f8/98eea607f65de6527f8a2e8885fc8015d3e6f5775df186e443e0964a11c3/distro-1.9.0.tar.gz"
    sha256 "2fa77c6fd8940f116ee1d6b94a2f90b13b5ea8d019b98bc8bafdcabcdd9bdbed"
  end

  resource "loguru" do
    url "https://files.pythonhosted.org/packages/3a/05/a1dae3dffd1116099471c643b8924f5aa6524411dc6c63fdae648c4f1aca/loguru-0.7.3.tar.gz"
    sha256 "19480589e77d47b8d85b2c827ad95d49bf31b0dcde16593892eb51dd18706eb6"
  end

  resource "maison" do
    url "https://files.pythonhosted.org/packages/24/45/7cb1d08b6b5674c381b6e0232d35f417a1eba8bb66cdc18edff2b9c80b68/maison-2.0.2.tar.gz"
    sha256 "476f2bf414a20f5abf5a9856bd4db78b5a33c695654a0fc49c3c4abed78c2efc"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/5b/f5/4ec618ed16cc4f8fb3b701563655a69816155e79e24a17b651541804721d/markdown_it_py-4.0.0.tar.gz"
    sha256 "cb0a2b4aa34f932c007117b194e945bd74e0ec24133ceb5bac59009cda1cb9f3"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/1b/04/fea538adf7dbbd6d186f551d595961e564a3b6715bdf276b477460858672/platformdirs-4.9.2.tar.gz"
    sha256 "9a33809944b9db043ad67ca0db94b14bf452cc6aeaac46a88ea55b26e2e9d291"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/b0/77/a5b8c569bf593b0140bde72ea885a803b82086995367bf2037de0159d924/pygments-2.19.2.tar.gz"
    sha256 "636cb2477cec7f8952536970bc533bc43743542f70392ae026374600add5b887"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/74/99/a4cab2acbb884f80e558b0771e97e21e939c5dfb460f488d19df485e8298/rich-14.3.2.tar.gz"
    sha256 "e712f11c1a562a11843306f5ed999475f09ac31ffb64281f73ab29ffdda8b3b8"
  end

  resource "ruyaml" do
    url "https://files.pythonhosted.org/packages/4b/75/abbc7eab08bad7f47887a0555d3ac9e3947f89d2416678c08e025e449fdc/ruyaml-0.91.0.tar.gz"
    sha256 "6ce9de9f4d082d696d3bde264664d1bcdca8f5a9dff9d1a1f1a127969ab871ab"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/82/f3/748f4d6f65d1756b9ae577f329c951cda23fb900e4de9f70900ced962085/setuptools-82.0.0.tar.gz"
    sha256 "22e0a2d69474c6ae4feb01951cb69d515ed23728cf96d05513d36e42b62b37cb"
  end

  resource "shellingham" do
    url "https://files.pythonhosted.org/packages/58/15/8b3609fd3830ef7b27b655beb4b4e9c62313a4e8da8c676e142cc210d58e/shellingham-1.5.4.tar.gz"
    sha256 "8dbca0739d487e5bd35ab3ca4b36e11c4078f3a234bfce294b0a0291363404de"
  end

  resource "typer" do
    url "https://files.pythonhosted.org/packages/5a/b6/3e681d3b6bb22647509bdbfdd18055d5adc0dce5c5585359fa46ff805fdc/typer-0.24.0.tar.gz"
    sha256 "f9373dc4eff901350694f519f783c29b6d7a110fc0dcc11b1d7e353b85ca6504"
  end

  def install
    # Workaround for ruyaml needing pkg_resources removed from setuptools 82+
    (buildpath/"build-constraints.txt").write "setuptools<82\n"
    ENV["PIP_BUILD_CONSTRAINT"] = buildpath/"build-constraints.txt"

    virtualenv_install_with_resources
    generate_completions_from_executable(bin/"yamlfix", shell_parameter_format: :click)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/yamlfix --version")

    (testpath/"test.yaml").write <<~YAML
      foo: bar
      baz: qux
    YAML

    assert_match <<~EOS, shell_output("#{bin}/yamlfix test.yaml 2>&1").gsub(/\e\[\d+m/, "")
      [+] YamlFix: Fixing files
      [+] Fixed test.yaml
      [+] Checked 1 files: 1 fixed, 0 left unchanged
    EOS

    expected_content = <<~YAML
      ---
      foo: bar
      baz: qux
    YAML

    assert_equal expected_content, (testpath/"test.yaml").read
  end
end
