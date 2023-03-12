class Virtualenv < Formula
  include Language::Python::Virtualenv

  desc "Tool for creating isolated virtual python environments"
  homepage "https://virtualenv.pypa.io/"
  url "https://files.pythonhosted.org/packages/87/14/ca9890d58cd33d9122eb87ffec2f3c6be0714785f992a0fd3b56a3b6c993/virtualenv-20.21.0.tar.gz"
  sha256 "f50e3e60f990a0757c9b68333c9fdaa72d7188caa417f96af9e52407831a3b68"
  license "MIT"
  head "https://github.com/pypa/virtualenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "265230a763d49724138d855e90aa0b59ca241a47a195b4f335d0537b6f792fc2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "214c2e49387ed883f1a08768de2e3ee44c4a0a9731f4df26525fa5ad3ed1d981"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bc14dd441f78307573b535a6ce5e7d5cf8298f2d91095fa329eb115a33171496"
    sha256 cellar: :any_skip_relocation, ventura:        "04d7babcad33f54fe9c96403533b5d49ca352247218a9b949ffc100fb2c35554"
    sha256 cellar: :any_skip_relocation, monterey:       "8784f872b44f3ce25ee406c040db1ca3a9ee0aaead4fe82817eaf773d8978893"
    sha256 cellar: :any_skip_relocation, big_sur:        "83815be6ba5db1c1c1e305982ebd8d5e02be1b4ea2a69d6e24daf993206c1511"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6042729a245ad951670a6ee1bceedceefeed89b8e0df15405d9b6853d4943873"
  end

  depends_on "python@3.11"

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/58/07/815476ae605bcc5f95c87a62b95e74a1bce0878bc7a3119bc2bf4178f175/distlib-0.3.6.tar.gz"
    sha256 "14bad2d9b04d3a36127ac97f30b12a19268f211063d8f8ee4f47108896e11b46"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/0b/dc/eac02350f06c6ed78a655ceb04047df01b02c6b7ea3fc02d4df24ca87d24/filelock-3.9.0.tar.gz"
    sha256 "7b319f24340b51f55a2bf7a12ac0755a9b03e718311dac567a0f4f7fabd2f5de"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/79/c4/f98a05535344f79699bbd494e56ac9efc986b7a253fe9f4dba7414a7f505/platformdirs-3.1.1.tar.gz"
    sha256 "024996549ee88ec1a9aa99ff7f8fc819bb59e2c3477b410d90a16d32d6e707aa"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system "#{bin}/virtualenv", "venv_dir"
    assert_match "venv_dir", shell_output("venv_dir/bin/python -c 'import sys; print(sys.prefix)'")
  end
end
