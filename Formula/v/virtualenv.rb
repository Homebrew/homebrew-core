class Virtualenv < Formula
  include Language::Python::Virtualenv

  desc "Tool for creating isolated virtual python environments"
  homepage "https://virtualenv.pypa.io/"
  url "https://files.pythonhosted.org/packages/38/e0/633e369b91bbc664df47dcb5454b6c7cf441e8f5b9d0c250ce9f0546401e/virtualenv-20.30.0.tar.gz"
  sha256 "800863162bcaa5450a6e4d721049730e7f2dae07720e0902b0e4040bd6f9ada8"
  license "MIT"
  head "https://github.com/pypa/virtualenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "349cdd4ae97b4c36bc8741295ff0004071dcd9977f3f0b72cba486241374a905"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "349cdd4ae97b4c36bc8741295ff0004071dcd9977f3f0b72cba486241374a905"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "349cdd4ae97b4c36bc8741295ff0004071dcd9977f3f0b72cba486241374a905"
    sha256 cellar: :any_skip_relocation, sonoma:        "f96e4a52a80d9a37ab639b5f1b76c010fe02891adb090497aae9f50e2433a69c"
    sha256 cellar: :any_skip_relocation, ventura:       "f96e4a52a80d9a37ab639b5f1b76c010fe02891adb090497aae9f50e2433a69c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d3c5d0abc536f284a2ee65921d1d443b74f33402d4e95b2a88612a6374086999"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d3c5d0abc536f284a2ee65921d1d443b74f33402d4e95b2a88612a6374086999"
  end

  depends_on "python@3.13"

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/0d/dd/1bec4c5ddb504ca60fc29472f3d27e8d4da1257a854e1d96742f15c1d02d/distlib-0.3.9.tar.gz"
    sha256 "a60f20dea646b8a33f3e7772f74dc0b2d0772d2837ee1342a00645c81edf9403"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/0a/10/c23352565a6544bdc5353e0b15fc1c563352101f30e24bf500207a54df9a/filelock-3.18.0.tar.gz"
    sha256 "adbc88eabb99d2fec8c9c1b229b171f18afa655400173ddc653d5d01501fb9f2"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/b6/2d/7d512a3913d60623e7eb945c6d1b4f0bddf1d0b7ada5225274c87e5b53d1/platformdirs-4.3.7.tar.gz"
    sha256 "eb437d586b6a0986388f0d6f74aa0cde27b48d0e3d66843640bfb6bdcdb6e351"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"virtualenv", "venv_dir"
    assert_match "venv_dir", shell_output("venv_dir/bin/python -c 'import sys; print(sys.prefix)'")
  end
end
