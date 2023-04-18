class Virtualenv < Formula
  include Language::Python::Virtualenv

  desc "Tool for creating isolated virtual python environments"
  homepage "https://virtualenv.pypa.io/"
  url "https://files.pythonhosted.org/packages/87/14/ca9890d58cd33d9122eb87ffec2f3c6be0714785f992a0fd3b56a3b6c993/virtualenv-20.21.0.tar.gz"
  sha256 "f50e3e60f990a0757c9b68333c9fdaa72d7188caa417f96af9e52407831a3b68"
  license "MIT"
  head "https://github.com/pypa/virtualenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fe2c6b70f79d511411b3a9765d568301031c6ad91174960f5d6eb99318a19612"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "266adec6db98929b0589ebff3f4cab50cd6a12402adccbaf6987837f541eb867"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0861b0c40f60d3bcb37daa2d020fd8130eb0a4f5c4dba562027b65e01a1d4abf"
    sha256 cellar: :any_skip_relocation, ventura:        "1f9f429e649c4ed20e7ddcac48708fd3288fc9d149ffd42c218429876ee5c31c"
    sha256 cellar: :any_skip_relocation, monterey:       "d366268f0a0735790df980efc831eb4bb555216bd2d57a3d73f7186e99710dfa"
    sha256 cellar: :any_skip_relocation, big_sur:        "f721b44a1bb1d5ca156cbef1808f6f05af89b4d9d3dd1de14e1e540cee76797e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d5f43fc03f801046897772ef446a2c2dea3a6c8d2dbab260ccd025aed824aa22"
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
