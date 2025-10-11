class Reuse < Formula
  include Language::Python::Virtualenv

  desc "Tool for copyright and license recommendations"
  homepage "https://reuse.software"
  url "https://files.pythonhosted.org/packages/76/b0/ffd3a8978504763982db4735b7d87fc16b57f4b511c49a38ca25a7cb9ad3/reuse-6.1.2.tar.gz"
  sha256 "6019a75f4ca18ad5b2506e0f3ec1b926b27ba6cdc9da88492e7fc65e3ff12c39"
  license all_of: [
    "GPL-3.0-or-later",
    "CC-BY-SA-4.0",
    "CC0-1.0",
    "Apache-2.0",
  ]
  head "https://github.com/fsfe/reuse-tool.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2b94a7a4dd90f3f016586f09850c2ea673af9732240a88fe8999ee4ff11bcda9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "15a5d532193aad234de2afd688687e443a2fed962a48e03e5177be268137b72e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f6f52383e243798fa8df2485ca8a6a26b0060d66f5fb67b6d20b24aa15147c1d"
    sha256 cellar: :any_skip_relocation, tahoe:         "85dded7468eedbece5d9b0cae796dc3b59a66185471bd62b598f9fd1cb5d40bb"
    sha256 cellar: :any_skip_relocation, sequoia:       "b97ccef2e8ac8ba187e8ee4ba2a8ee51ee2b8d43e687df3bf4d9c8472d1ae7f7"
    sha256 cellar: :any_skip_relocation, sonoma:        "83e6b31e9d621f1a289dfd8973d7cde17767264e0b22456abc519af822c76490"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "09d9c5ba25e1e04b415f303b59bc64bc98b629088b75d934a0e2ecbe64857295"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0658592215a02ef5ab44cd477a6b020d538c08179471884f5628ef4cdbb90301"
  end

  depends_on "python@3.14"

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/6b/5c/685e6633917e101e5dcb62b9dd76946cbb57c26e133bae9e0cd36033c0a9/attrs-25.4.0.tar.gz"
    sha256 "16d5969b87f0859ef33a48b35d55ac1be6e42ae49d5e853b597db70c35c57e11"
  end

  resource "boolean-py" do
    url "https://files.pythonhosted.org/packages/c4/cf/85379f13b76f3a69bca86b60237978af17d6aa0bc5998978c3b8cf05abb2/boolean_py-5.0.tar.gz"
    sha256 "60cbc4bad079753721d32649545505362c754e121570ada4658b852a3a318d95"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/83/2d/5fd176ceb9b2fc619e63405525573493ca23441330fcdaee6bef9460e924/charset_normalizer-3.4.3.tar.gz"
    sha256 "6fce4b8500244f6fcb71465d4a4930d132ba9ab8e71a7859e6a5d59851068d14"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/46/61/de6cd827efad202d7057d93e0fed9294b96952e188f7384832791c7b2254/click-8.3.0.tar.gz"
    sha256 "e7b8232224eba16f4ebe410c25ced9f7875cb5f3263ffc93cc3e8da705e229c4"
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
    url "https://files.pythonhosted.org/packages/7e/99/7690b6d4034fffd95959cbe0c02de8deb3098cc577c67bb6a24fe5d7caa7/markupsafe-3.0.3.tar.gz"
    sha256 "722695808f4b6457b320fdc131280796bdceb04ab50fe1795cd540799ebe1698"
  end

  resource "python-debian" do
    url "https://files.pythonhosted.org/packages/bf/4b/3c4cf635311b6203f17c2d693dc15e898969983dd3f729bee3c428aa60d4/python-debian-1.0.1.tar.gz"
    sha256 "3ada9b83a3d671b58081782c0969cffa0102f6ce433fbbc7cf21275b8b5cc771"
  end

  resource "python-magic" do
    url "https://files.pythonhosted.org/packages/da/db/0b3e28ac047452d079d375ec6798bf76a036a08182dbb39ed38116a49130/python-magic-0.4.27.tar.gz"
    sha256 "c1ba14b08e4a5f5c31a302b7721239695b2f0f058d125bd5ce1ee36b9d9d3c3b"
  end

  resource "tomlkit" do
    url "https://files.pythonhosted.org/packages/cc/18/0bbf3884e9eaa38819ebe46a7bd25dcd56b67434402b66a58c4b8e552575/tomlkit-0.13.3.tar.gz"
    sha256 "430cf247ee57df2b94ee3fbe588e71d362a941ebb545dec29b53961d61add2a1"
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
