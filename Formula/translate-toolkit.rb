class TranslateToolkit < Formula
  include Language::Python::Virtualenv

  desc "Toolkit for localization engineers"
  homepage "https://toolkit.translatehouse.org/"
  url "https://files.pythonhosted.org/packages/a2/97/77b83392bc0a454a9454ba2211cd5380856323df55b870f14a645bb6882a/translate-toolkit-3.8.0.tar.gz"
  sha256 "330e79b272ebbfce7115b38e6f7cbb57352be6ae9bddc6306ff2ee6e1a569905"
  license "GPL-2.0-or-later"
  head "https://github.com/translate/translate.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "249e983b219e9698e2c041b66819d3d064faf40666a791d2cc6b7e3d2c150985"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "94b67704c25949fb2d86c43aed68401167653d10cc5d44a86ba8eba40ed8d053"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "df2f57e90353e136aa2531ca2f05603e6c68d7e66a743f396ee691a3a5c58614"
    sha256 cellar: :any_skip_relocation, ventura:        "f52a06e2546bd161e52f209f008f5a5d2e2093933cbbfaee5ecb55a96a09f515"
    sha256 cellar: :any_skip_relocation, monterey:       "7936d18ec3104c8147d060abbe947ccaedb33bde7691860dbc777b3613e83738"
    sha256 cellar: :any_skip_relocation, big_sur:        "b484b8b038df210d2a0361beae2c586319f7aaca4bfaeb1c551be91f8461ac7a"
    sha256 cellar: :any_skip_relocation, catalina:       "74693cf129197e81fd9a0675ce47e5af62faebe84c285e91e53dd1d031646269"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "72ebf9aa3d60b1288969cb9535f79a1640cfa12fab6852c3b79c980db9635fd5"
  end

  depends_on "python@3.11"

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/70/bb/7a2c7b4f8f434aa1ee801704bf08f1e53d7b5feba3d5313ab17003477808/lxml-4.9.1.tar.gz"
    sha256 "fe749b052bb7233fe5d072fcb549221a8cb1a16725c47c37e42b0b9cb3ff2c3f"
  end

  def install
    # Workaround to avoid creating libexec/bin/__pycache__ which gets linked to bin
    ENV["PYTHONPYCACHEPREFIX"] = buildpath/"pycache"

    virtualenv_install_with_resources
  end

  test do
    system bin/"pretranslate", "-h"
    system bin/"podebug", "-h"
  end
end
