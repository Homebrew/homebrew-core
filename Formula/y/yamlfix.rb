class Yamlfix < Formula
  include Language::Python::Virtualenv

  desc "Simple and configurable YAML formatter that keeps comments"
  homepage "https://lyz-code.github.io/yamlfix/"
  url "https://files.pythonhosted.org/packages/a9/04/e5061d4c353fad1240356458c999ddd452315a2485c3e8b00159767b3567/yamlfix-1.17.0.tar.gz"
  sha256 "81d7220b62798d1dda580e1574b3d3d6926701ae8cd79588c4e0b33f2e345d85"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "badcb1e0519bceb4de7cd7db81a69c4947230941656959a170cd0a98668a66b1"
    sha256 cellar: :any,                 arm64_sonoma:  "a9cf9fbed2979245068bd2e15cac71ffc87623f77bd35fac4a9ba68836c1fdb2"
    sha256 cellar: :any,                 arm64_ventura: "d1e35c718ba628e672c8ae7b4d6970f4d6baa180425764b839c1e98be5d28166"
    sha256 cellar: :any,                 sonoma:        "a4fdb343c7e93340801caf53a1b4c7ef98f657d149d93985d7f480dade902c82"
    sha256 cellar: :any,                 ventura:       "54c2f7af91fa5db4af9520a588bfe788ff2aa5235adbd48e7940c07e89297091"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "37cd912b1a80fb673bc4bbb83a370e840e392bcad4c29fec5dba54bec555f575"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e2329c6594e7413ce24f09fd3ad8d601204d5c985667ce8a6aa12f86566cfe2"
  end

  depends_on "rust" => :build # for pydantic_core
  depends_on "python@3.13"

  resource "annotated-types" do
    url "https://files.pythonhosted.org/packages/ee/67/531ea369ba64dcff5ec9c3402f9f51bf748cec26dde048a2f973a4eea7f5/annotated_types-0.7.0.tar.gz"
    sha256 "aff07c09a53a08bc8cfccb9c85b05f1aa9a2a6f23728d790723543408344ce89"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/b9/2e/0090cbf739cee7d23781ad4b89a9894a41538e4fcf4c31dcdd705b78eb8b/click-8.1.8.tar.gz"
    sha256 "ed53c9d8990d83c2a27deae68e4ee337473f6330c040a31d4225c9574d16096a"
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
    url "https://files.pythonhosted.org/packages/b7/ae/d5220c5c52b158b1de7ca89fc5edb72f304a70a4c540c84c8844bf4008de/pydantic-2.10.6.tar.gz"
    sha256 "ca5daa827cce33de7a42be142548b0096bf05a7e7b365aebfa5f8eeec7128236"
  end

  resource "pydantic-core" do
    url "https://files.pythonhosted.org/packages/fc/01/f3e5ac5e7c25833db5eb555f7b7ab24cd6f8c322d3a3ad2d67a952dc0abc/pydantic_core-2.27.2.tar.gz"
    sha256 "eb026e5a4c1fee05726072337ff51d1efb6f59090b7da90d30ea58625b1ffb39"
  end

  resource "ruyaml" do
    url "https://files.pythonhosted.org/packages/4b/75/abbc7eab08bad7f47887a0555d3ac9e3947f89d2416678c08e025e449fdc/ruyaml-0.91.0.tar.gz"
    sha256 "6ce9de9f4d082d696d3bde264664d1bcdca8f5a9dff9d1a1f1a127969ab871ab"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/92/ec/089608b791d210aec4e7f97488e67ab0d33add3efccb83a056cbafe3a2a6/setuptools-75.8.0.tar.gz"
    sha256 "c5afc8f407c626b8313a86e10311dd3f661c6cd9c09d4bf8c15c0e11f9f2b0e6"
  end

  resource "toml" do
    url "https://files.pythonhosted.org/packages/be/ba/1f744cdc819428fc6b5084ec34d9b30660f6f9daaf70eead706e3203ec3c/toml-0.10.2.tar.gz"
    sha256 "b3bda1d108d5dd99f4a20d24d9c348e91c4db7ab1b749200bded2f839ccbe68f"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/df/db/f35a00659bc03fec321ba8bce9420de607a1d37f8342eee1863174c69557/typing_extensions-4.12.2.tar.gz"
    sha256 "1a7ead55c7e559dd4dee8856e3a88b41225abfe1ce8df57b7c13915fe121ffb8"
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
