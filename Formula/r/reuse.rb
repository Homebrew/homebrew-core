class Reuse < Formula
  include Language::Python::Virtualenv

  desc "Tool for copyright and license recommendations"
  homepage "https://reuse.software"
  url "https://files.pythonhosted.org/packages/05/35/298d9410b3635107ce586725cdfbca4c219c08d77a3511551f5e479a78db/reuse-6.2.0.tar.gz"
  sha256 "4feae057a2334c9a513e6933cdb9be819d8b822f3b5b435a36138bd218897d23"
  license all_of: [
    "GPL-3.0-or-later",
    "CC-BY-SA-4.0",
    "CC0-1.0",
    "Apache-2.0",
  ]
  revision 1
  head "https://github.com/fsfe/reuse-tool.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "fc573fb13b8eb2f85268bd5ffcbb48475fec9758d7c35cdd7a5820c0b9f34963"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8fa0fd4e4929623042f81e4cac6d3dca46710e5ad1d756272c4834ec724d2df4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1043b8bec8d72e602cf2dc7edfebd75f890aa83dc0eecd6e5df760793939a549"
    sha256 cellar: :any,                 arm64_linux:       "77460fd9c6f8d9130cd3efe93b963395d172e6618f711882ed2b3de490fce67c"
    sha256 cellar: :any,                 x86_64_linux:      "d0e660560105789f2492451ad2a562c190e49001a40a712ded0892ccfd98561e"
  end

  depends_on "python@3.15"

  pypi_packages package_name: "reuse[charset-normalizer]"

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/9a/8e/82a0fe20a541c03148528be8cac2408564a6c9a0cc7e9171802bc1d26985/attrs-26.1.0.tar.gz"
    sha256 "d03ceb89cb322a8fd706d4fb91940737b6642aa36998fe130a9bc96c985eff32"
  end

  resource "boolean-py" do
    url "https://files.pythonhosted.org/packages/c4/cf/85379f13b76f3a69bca86b60237978af17d6aa0bc5998978c3b8cf05abb2/boolean_py-5.0.tar.gz"
    sha256 "60cbc4bad079753721d32649545505362c754e121570ada4658b852a3a318d95"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/33/1c/f41d4e74c28ab327ff3acd36053f7ea506c55872d7a90b0fa71aa3ab0c89/charset_normalizer-3.5.2.tar.gz"
    sha256 "39de2a259fc954455c57274dc94c79d5842774e1247a016aff30bc0efed0f4ef"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/c7/0e/7fa0ef50764b67090eca4114772a2abf8b6148198475e54c660b97caeee6/click-8.5.0.tar.gz"
    sha256 "ba0d2089de75ea0310e2dde03160e6ca10009947fb95a182f9b54021bb272e34"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "license-expression" do
    url "https://files.pythonhosted.org/packages/40/71/d89bb0e71b1415453980fd32315f2a037aad9f7f70f695c7cec7035feb13/license_expression-30.4.4.tar.gz"
    sha256 "73448f0aacd8d0808895bdc4b2c8e01a8d67646e4188f887375398c761f340fd"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/38/9b/e422a865e1d5d57d0e509b4e0bf1c1a70a7f6382c29a5aa428df994c8bc8/markupsafe-3.0.4.tar.gz"
    sha256 "2e9ad7dd851bf45fab9f75cbff4cb493fee9979e8d8c7c9c3ee119022518edd6"
  end

  resource "python-debian" do
    url "https://files.pythonhosted.org/packages/75/36/f90e7d006dd9311a6185f1c34b403dd6d76ff583e7962c56e9374c462a48/python_debian-1.1.1.tar.gz"
    sha256 "fe4fc3dc798dbf1f0ef5865e2b1b4f7cc0352b6a511b25ab7594906c64a73629"
  end

  resource "python-magic" do
    url "https://files.pythonhosted.org/packages/da/db/0b3e28ac047452d079d375ec6798bf76a036a08182dbb39ed38116a49130/python-magic-0.4.27.tar.gz"
    sha256 "c1ba14b08e4a5f5c31a302b7721239695b2f0f058d125bd5ce1ee36b9d9d3c3b"
  end

  resource "tomlkit" do
    url "https://files.pythonhosted.org/packages/94/96/e07752635b98536177fa1f37671c8f3cdde2e724c6bcf6034b2cfb571565/tomlkit-0.15.1.tar.gz"
    sha256 "e25bbf38843005246210a12982776f27f99cb9be67160e14434d0c0d21ee1e97"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"reuse", shell_parameter_format: :click)
  end

  test do
    (testpath/"testfile.rb").write ""
    system bin/"reuse", "annotate", "--copyright=Homebrew Maintainers",
                  "--exclude-year",
                  "--license=BSD-2-Clause",
                  testpath/"testfile.rb"
    header = <<~RUBY
      # SPDX-FileCopyrightText: Homebrew Maintainers
      #
      # SPDX-License-Identifier: BSD-2-Clause
    RUBY
    assert_equal header, (testpath/"testfile.rb").read
    system bin/"reuse", "download", "BSD-2-Clause"
    assert_path_exists testpath/"LICENSES/BSD-2-Clause.txt"
  end
end
