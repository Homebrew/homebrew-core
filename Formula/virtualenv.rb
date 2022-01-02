class Virtualenv < Formula
  include Language::Python::Virtualenv

  desc "Tool for creating isolated virtual python environments"
  homepage "https://virtualenv.pypa.io/"
  url "https://files.pythonhosted.org/packages/f1/db/4498de0294f0c72a2e0a099d1588e7b55d0c849db740c89978ff73700519/virtualenv-20.13.0.tar.gz"
  sha256 "d8458cf8d59d0ea495ad9b34c2599487f8a7772d796f9910858376d1600dd2dd"
  license "MIT"
  head "https://github.com/pypa/virtualenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "94345f1c273c558f964788cdb96c82e469debd39b1982e0a395d58781e64535a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1a62688cebe5ce63596c4bd0072c5927c66e0fdd54eabb982ee1f346a0a8377d"
    sha256 cellar: :any_skip_relocation, monterey:       "df47997a828084ccd463665018c719d4bc62a37565cc24ec78202fbba53022cd"
    sha256 cellar: :any_skip_relocation, big_sur:        "6e742adf7b686b744136991cdc3af0bf104b1672a6986bb970fbd6a783b91c21"
    sha256 cellar: :any_skip_relocation, catalina:       "80ca8a2af1cb3055daf1bd77fcdd78b7579732e8ea9f26e5358ea64c4518fc6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f9ddcf46b8923ca78e35c249b8bc5e865b4bb3b50b39fb6a26e9e601b7a3c627"
  end

  depends_on "python@3.10"
  depends_on "six"

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/85/01/88529c93e41607f1a78c1e4b346b24c74ee43d2f41cfe33ecd2e20e0c7e3/distlib-0.3.4.zip"
    sha256 "e4b58818180336dc9c529bfb9a0b58728ffc09ad92027a3f30b7cd91e3458579"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/11/d1/22318a1b5bb06c9be4c065ad6a09cb7bfade737758dc08235c99cd6cf216/filelock-3.4.2.tar.gz"
    sha256 "38b4f4c989f9d06d44524df1b24bd19e167d851f19b50bf3e3559952dddc5b80"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/be/00/bd080024010e1652de653bd61181e2dfdbef5fa73bfd32fec4c808991c31/platformdirs-2.4.1.tar.gz"
    sha256 "440633ddfebcc36264232365d7840a970e75e1018d15b4327d11f91909045fda"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system "#{bin}/virtualenv", "venv_dir"
    assert_match "venv_dir", shell_output("venv_dir/bin/python -c 'import sys; print(sys.prefix)'")
  end
end
