class Virtualenv < Formula
  include Language::Python::Virtualenv

  desc "Tool for creating isolated virtual python environments"
  homepage "https://virtualenv.pypa.io/"
  url "https://files.pythonhosted.org/packages/c7/3e/b11275c99dd779e4fc87931f7c82ce93767080249bfa4d7aea7ea748800e/virtualenv-20.10.0.tar.gz"
  sha256 "576d05b46eace16a9c348085f7d0dc8ef28713a2cabaa1cf0aea41e8f12c9218"
  license "MIT"
  head "https://github.com/pypa/virtualenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ce2901614eb28e009f454472c28eac2ddb73312edcfbe7ecf856e839447bed1b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e243a4b3be1875d313c17021a39bfca69f8adffe1835317bc31214f5c17b027d"
    sha256 cellar: :any_skip_relocation, monterey:       "9391a498f1cc93c3b2e2c72cf0700f270ec8d223d5dedf8baef8ca9b58bdfb75"
    sha256 cellar: :any_skip_relocation, big_sur:        "3ca54ec5105fd918ddfe32c3ba9d36402eebb08859f43bdcfbf66a17c70b69e8"
    sha256 cellar: :any_skip_relocation, catalina:       "4455eb82c916514636f7c0641f0daa2b651c5ad89add521323fb615e53ec4362"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c577f3965af7150bffa171b03248c3f28165f51ea7c9e6399afd671a3dc20cf2"
  end

  depends_on "python@3.10"
  depends_on "six"

  resource "backports.entry-points-selectable" do
    url "https://files.pythonhosted.org/packages/e4/7e/249120b1ba54c70cf988a8eb8069af1a31fd29d42e3e05b9236a34533533/backports.entry_points_selectable-1.1.0.tar.gz"
    sha256 "988468260ec1c196dab6ae1149260e2f5472c9110334e5d51adcb77867361f6a"
  end

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/56/ed/9c876a62efda9901863e2cc8825a13a7fcbda75b4b498103a4286ab1653b/distlib-0.3.3.zip"
    sha256 "d982d0751ff6eaaab5e2ec8e691d949ee80eddf01a62eaa96ddb11531fe16b05"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/4f/c5/477ff63917e7670fe1f338a0226fbb1f654e4cbb2656f5c3ba81f5c26929/filelock-3.3.2.tar.gz"
    sha256 "7afc856f74fa7006a289fd10fa840e1eebd8bbff6bffb69c26c54a0512ea8cf8"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/4b/96/d70b9462671fbeaacba4639ff866fb4e9e558580853fc5d6e698d0371ad4/platformdirs-2.4.0.tar.gz"
    sha256 "367a5e80b3d04d2428ffa76d33f124cf11e8fff2acdaa9b43d545f5c7d661ef2"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system "#{bin}/virtualenv", "venv_dir"
    assert_match "venv_dir", shell_output("venv_dir/bin/python -c 'import sys; print(sys.prefix)'")
  end
end
