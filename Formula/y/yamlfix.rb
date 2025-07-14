class Yamlfix < Formula
  include Language::Python::Virtualenv

  desc "Simple and configurable YAML formatter that keeps comments"
  homepage "https://lyz-code.github.io/yamlfix/"
  url "https://files.pythonhosted.org/packages/a9/04/e5061d4c353fad1240356458c999ddd452315a2485c3e8b00159767b3567/yamlfix-1.17.0.tar.gz"
  sha256 "81d7220b62798d1dda580e1574b3d3d6926701ae8cd79588c4e0b33f2e345d85"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e88dc2c841ca7281bea7728c94da6249b84c3eec37e3af45a7e4df8ae98dda70"
    sha256 cellar: :any,                 arm64_sonoma:  "6bb3222bccb1dd5dbc522e44443ab4e349102bbf224225de8c80300aed2084bc"
    sha256 cellar: :any,                 arm64_ventura: "d557584a6d6c134e0b28d7cb6ae1822e02c4c42e6dae7e9e0b6f7744ec798d4a"
    sha256 cellar: :any,                 sonoma:        "f2544cd1f120fa8c45d7caae4c9cce0f1e628e37dabc9f9520361335f29fa04c"
    sha256 cellar: :any,                 ventura:       "6038a7c186c310701dd56d1a90c044fb3ee59e8ce8c53701e718594db607d0d2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2113eda75d9df2870158f71322a97186e88ec93cfdedb0de42c16e63c543ee9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "83d1aa0f54f512923df57b0044d55a09f9493e6fb973586db7f6261978cd1a30"
  end

  depends_on "rust" => :build # for pydantic_core
  depends_on "python@3.13"

  resource "annotated-types" do
    url "https://files.pythonhosted.org/packages/ee/67/531ea369ba64dcff5ec9c3402f9f51bf748cec26dde048a2f973a4eea7f5/annotated_types-0.7.0.tar.gz"
    sha256 "aff07c09a53a08bc8cfccb9c85b05f1aa9a2a6f23728d790723543408344ce89"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/cd/0f/62ca20172d4f87d93cf89665fbaedcd560ac48b465bd1d92bfc7ea6b0a41/click-8.2.0.tar.gz"
    sha256 "f5452aeddd9988eefa20f90f05ab66f17fce1ee2a36907fd30b05bbb5953814d"
  end

  resource "distro" do
    url "https://files.pythonhosted.org/packages/fc/f8/98eea607f65de6527f8a2e8885fc8015d3e6f5775df186e443e0964a11c3/distro-1.9.0.tar.gz"
    sha256 "2fa77c6fd8940f116ee1d6b94a2f90b13b5ea8d019b98bc8bafdcabcdd9bdbed"
  end

  resource "maison" do
    url "https://files.pythonhosted.org/packages/2e/c5/c0574d47920f30eb84938bbe5220b249bde9b648b4517e1726e50a4b0967/maison-2.0.0.tar.gz"
    sha256 "f5dafbbf4ce57bdb7cae128e075f457434b2cc9573b4f4bb4535f16d2ebd1cc5"
  end

  resource "pydantic" do
    url "https://files.pythonhosted.org/packages/77/ab/5250d56ad03884ab5efd07f734203943c8a8ab40d551e208af81d0257bf2/pydantic-2.11.4.tar.gz"
    sha256 "32738d19d63a226a52eed76645a98ee07c1f410ee41d93b4afbfa85ed8111c2d"
  end

  resource "pydantic-core" do
    url "https://files.pythonhosted.org/packages/ad/88/5f2260bdfae97aabf98f1778d43f69574390ad787afb646292a638c923d4/pydantic_core-2.33.2.tar.gz"
    sha256 "7cb8bc3605c29176e1b105350d2e6474142d7c1bd1d9327c4a9bdb46bf827acc"
  end

  resource "ruyaml" do
    url "https://files.pythonhosted.org/packages/4b/75/abbc7eab08bad7f47887a0555d3ac9e3947f89d2416678c08e025e449fdc/ruyaml-0.91.0.tar.gz"
    sha256 "6ce9de9f4d082d696d3bde264664d1bcdca8f5a9dff9d1a1f1a127969ab871ab"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/9e/8b/dc1773e8e5d07fd27c1632c45c1de856ac3dbf09c0147f782ca6d990cf15/setuptools-80.7.1.tar.gz"
    sha256 "f6ffc5f0142b1bd8d0ca94ee91b30c0ca862ffd50826da1ea85258a06fd94552"
  end

  resource "toml" do
    url "https://files.pythonhosted.org/packages/be/ba/1f744cdc819428fc6b5084ec34d9b30660f6f9daaf70eead706e3203ec3c/toml-0.10.2.tar.gz"
    sha256 "b3bda1d108d5dd99f4a20d24d9c348e91c4db7ab1b749200bded2f839ccbe68f"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/f6/37/23083fcd6e35492953e8d2aaaa68b860eb422b34627b13f2ce3eb6106061/typing_extensions-4.13.2.tar.gz"
    sha256 "e6c81219bd689f51865d9e372991c540bda33a0379d5573cddb9a3a23f7caaef"
  end

  resource "typing-inspection" do
    url "https://files.pythonhosted.org/packages/82/5c/e6082df02e215b846b4b8c0b887a64d7d08ffaba30605502639d44c06b82/typing_inspection-0.4.0.tar.gz"
    sha256 "9765c87de36671694a67904bf2c96e395be9c6439bb6c87b5142569dcdd65122"
  end

  def install
    virtualenv_install_with_resources
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
