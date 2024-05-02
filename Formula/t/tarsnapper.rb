class Tarsnapper < Formula
  include Language::Python::Virtualenv

  desc "Tarsnap wrapper which expires backups using a gfs-scheme"
  homepage "https://github.com/miracle2k/tarsnapper"
  url "https://files.pythonhosted.org/packages/4e/c5/0a08950e5faba96e211715571c68ef64ee37b399ef4f0c4ab55e66c3c4fe/tarsnapper-0.5.0.tar.gz"
  sha256 "b129b0fba3a24b2ce80c8a2ecd4375e36b6c7428b400e7b7ab9ea68ec9bb23ec"
  license "BSD-2-Clause"
  revision 1

  bottle do
    rebuild 5
    sha256 cellar: :any,                 arm64_sonoma:   "9742393b148810a665b9af397ecb3084d84e83d5653ed1e76e955f8b9f897652"
    sha256 cellar: :any,                 arm64_ventura:  "55097042c81e1a943970310f57c471ad3b8dd174665d9587d459dcd761a64b5b"
    sha256 cellar: :any,                 arm64_monterey: "c37b0bca9437389af8569f18724d3510612a528c9a443e21b4ccfeafe319487c"
    sha256 cellar: :any,                 sonoma:         "d1f61623dcc854af71e22d44f1efeec81d6c9a42c050eed02d5fa52f09d30982"
    sha256 cellar: :any,                 ventura:        "bd26e2b4728637414f25ccce75e0a000ce7d4788070157370280ca8fef89487c"
    sha256 cellar: :any,                 monterey:       "b6bf153731a8f5a0242c3b69ab84f32579e8a905522a1e3abcaf38d121ebfeae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ca4f4379c2c1309b50cdfaebb62082088a9af18a5a3353267d975413fe688b0f"
  end

  depends_on "libyaml"
  depends_on "python@3.12"
  depends_on "tarsnap"

  resource "pexpect" do
    url "https://files.pythonhosted.org/packages/42/92/cc564bf6381ff43ce1f4d06852fc19a2f11d180f23dc32d9588bee2f149d/pexpect-4.9.0.tar.gz"
    sha256 "ee7d41123f3c9911050ea2c2dac107568dc43b2d3b0c7557a33212c398ead30f"
  end

  resource "ptyprocess" do
    url "https://files.pythonhosted.org/packages/20/e5/16ff212c1e452235a90aeb09066144d0c5a6a8c0834397e03f5224495c4e/ptyprocess-0.7.0.tar.gz"
    sha256 "5c5d0a3b48ceee0b48485e0c26037c0acd7d29765ca3fbb5cb3831d347423220"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/cd/e5/af35f7ea75cf72f2cd079c95ee16797de7cd71f29ea7c68ae5ce7be1eda0/PyYAML-6.0.1.tar.gz"
    sha256 "bfdf460b1736c775f2ba9f6a92bca30bc2095067b8a9d77876d1fad6cc3b4a43"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "usage: tarsnapper", shell_output("#{bin}/tarsnapper --help")
  end
end
