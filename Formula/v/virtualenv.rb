class Virtualenv < Formula
  include Language::Python::Virtualenv

  desc "Tool for creating isolated virtual python environments"
  homepage "https://virtualenv.pypa.io/"
  url "https://files.pythonhosted.org/packages/a7/ca/f23dcb02e161a9bba141b1c08aa50e8da6ea25e6d780528f1d385a3efe25/virtualenv-20.29.1.tar.gz"
  sha256 "b8b8970138d32fb606192cb97f6cd4bb644fa486be9308fb9b63f81091b5dc35"
  license "MIT"
  head "https://github.com/pypa/virtualenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "53bfe76e58460f891211c65632b0dccd9677daacd5d0ce3ebb02b4d4d80efff6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "53bfe76e58460f891211c65632b0dccd9677daacd5d0ce3ebb02b4d4d80efff6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "53bfe76e58460f891211c65632b0dccd9677daacd5d0ce3ebb02b4d4d80efff6"
    sha256 cellar: :any_skip_relocation, sonoma:        "7c5267faccd85d1087a98dafe2411197f9f576b431d5717e862608e2f34abbe0"
    sha256 cellar: :any_skip_relocation, ventura:       "7c5267faccd85d1087a98dafe2411197f9f576b431d5717e862608e2f34abbe0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "17103b335f2c47f798724c7de354ab057f3c89d5c7ed750d94f70be3a69762c5"
  end

  depends_on "python@3.13"

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/0d/dd/1bec4c5ddb504ca60fc29472f3d27e8d4da1257a854e1d96742f15c1d02d/distlib-0.3.9.tar.gz"
    sha256 "a60f20dea646b8a33f3e7772f74dc0b2d0772d2837ee1342a00645c81edf9403"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/9d/db/3ef5bb276dae18d6ec2124224403d1d67bccdbefc17af4cc8f553e341ab1/filelock-3.16.1.tar.gz"
    sha256 "c249fbfcd5db47e5e2d6d62198e565475ee65e4831e2561c8e313fa7eb961435"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/13/fc/128cc9cb8f03208bdbf93d3aa862e16d376844a14f9a0ce5cf4507372de4/platformdirs-4.3.6.tar.gz"
    sha256 "357fb2acbc885b0419afd3ce3ed34564c13c9b95c89360cd9563f73aa5e2b907"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"virtualenv", "venv_dir"
    assert_match "venv_dir", shell_output("venv_dir/bin/python -c 'import sys; print(sys.prefix)'")
  end
end
