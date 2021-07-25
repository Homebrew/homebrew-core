class SqliteUtils < Formula
  include Language::Python::Virtualenv
  desc "CLI utility for manipulating SQLite databases"
  homepage "https://sqlite-utils.datasette.io/"
  url "https://files.pythonhosted.org/packages/9a/ed/af78bfd037923f29aecb40b3686bfb8880b024449c7b89a2563da57679bd/sqlite-utils-3.13.tar.gz"
  sha256 "8c9ae307ba647497b57e8442351b975a96a93e32c594e868c4d5f8402ea6b65e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "0aaed030bd36c3adb9096031825156a0fbc8893d5b1c77d17acb3a6f9b406cbe"
    sha256 cellar: :any_skip_relocation, big_sur:       "72ab871b0f8f851e1614d209a08bc012cc250e4ea912c7ac6bea59436eef69ed"
    sha256 cellar: :any_skip_relocation, catalina:      "72ab871b0f8f851e1614d209a08bc012cc250e4ea912c7ac6bea59436eef69ed"
    sha256 cellar: :any_skip_relocation, mojave:        "72ab871b0f8f851e1614d209a08bc012cc250e4ea912c7ac6bea59436eef69ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f6f7d0d9686b5a8670dcfcbd2d3a436365b69e347a9bdc2e2b797b284aee6257"
  end

  depends_on "python-tabulate"
  depends_on "python@3.9"

  resource "click" do
    url "https://files.pythonhosted.org/packages/21/83/308a74ca1104fe1e3197d31693a7a2db67c2d4e668f20f43a2fca491f9f7/click-8.0.1.tar.gz"
    sha256 "8c04c11192119b1ef78ea049e0a6f0463e4c48ef00a30160c704337586f3ad7a"
  end

  resource "click-default-group" do
    url "https://files.pythonhosted.org/packages/22/3a/e9feb3435bd4b002d183fcb9ee08fb369a7e570831ab1407bc73f079948f/click-default-group-1.2.2.tar.gz"
    sha256 "d9560e8e8dfa44b3562fbc9425042a0fd6d21956fcc2db0077f63f34253ab904"
  end

  resource "sqlite-fts4" do
    url "https://files.pythonhosted.org/packages/62/30/63e64b7b8fa69aabf97b14cbc204cb9525eb2132545f82231c04a6d40d5c/sqlite-fts4-1.0.1.tar.gz"
    sha256 "b2d4f536a28181dc4ced293b602282dd982cc04f506cf3fc491d18b824c2f613"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "15", shell_output("#{bin}/sqlite-utils :memory: 'select 3 * 5'")
  end
end
