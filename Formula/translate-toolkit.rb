class TranslateToolkit < Formula
  include Language::Python::Virtualenv

  desc "Toolkit for localization engineers"
  homepage "https://toolkit.translatehouse.org/"
  url "https://files.pythonhosted.org/packages/43/62/413b9a7d76f651fc61c4a0f24554f3023a63b243340ddf12427ecc3a9621/translate-toolkit-3.5.3.tar.gz"
  sha256 "b7ca3e0e8f69c306c372e05a0a814ecafa6176d30ce314e787378dabf3e48dfb"
  license "GPL-2.0-or-later"
  head "https://github.com/translate/translate.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9ed3b586db8c116447014087e1e72563221f58967e9a69d4d98e71255751cd33"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2f38a15334a68d3ec39e6bfd4890d5fff1b51f6425c2b6064bcef0fd1b23d94b"
    sha256 cellar: :any_skip_relocation, monterey:       "91433ead60b231393b25a6f3bb0144619b0f2da9168a3ba8fbac7be848b8a675"
    sha256 cellar: :any_skip_relocation, big_sur:        "ab99b07055dd135a5299e8df13453d506c646ee51b290ee6b3f5e82aa5d24110"
    sha256 cellar: :any_skip_relocation, catalina:       "c5171ef29ca5816575addd2f7c138e191abd42c5d219f2001432a7c65a3709d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d9e1840db176c6c816aaf91250d49581fceab5149cc24550844f7f0f8e55dc6b"
  end

  depends_on "python@3.10"

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/84/74/4a97db45381316cd6e7d4b1eb707d7f60d38cb2985b5dfd7251a340404da/lxml-4.7.1.tar.gz"
    sha256 "a1613838aa6b89af4ba10a0f3a972836128801ed008078f8c1244e65958f1b24"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"pretranslate", "-h"
    system bin/"podebug", "-h"
  end
end
