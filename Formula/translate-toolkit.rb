class TranslateToolkit < Formula
  include Language::Python::Virtualenv

  desc "Toolkit for localization engineers"
  homepage "https://toolkit.translatehouse.org/"
  url "https://files.pythonhosted.org/packages/1b/c0/66d7c2deb7fd9072cbf886b6f35d796cf24a87f23e3033dfdc1f5d71ac7b/translate-toolkit-3.6.1.tar.gz"
  sha256 "863483edbe51906e9baf9157c2ac22dd42ad07e740d58cc430db20175383da8a"
  license "GPL-2.0-or-later"
  head "https://github.com/translate/translate.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "792eac8def9c96629152a3a081798b110d367335b864ce0d39896162802d754f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1969a9eeaae2617fb3ec8981ae13aea597b579f59882b41f547f8fa67cc472fd"
    sha256 cellar: :any_skip_relocation, monterey:       "3f5d42d4c0e6a7ed4736abdbbfe550b67e16767e050c7e4b8e6926091739581f"
    sha256 cellar: :any_skip_relocation, big_sur:        "dd18226af4ad0a7985369ac251f30e5b53927a8ad746d7004bc9a5aa2298cd2f"
    sha256 cellar: :any_skip_relocation, catalina:       "06ae086f7757ee2469dfc7e8dfd4a46b380a6984831ea530cfd6ee7d3a60d79f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cd6b9313cbe87a971815c5f0115793fe73a74c80b5dccb7dfc01641c51f68a15"
  end

  depends_on "python@3.10"

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/3b/94/e2b1b3bad91d15526c7e38918795883cee18b93f6785ea8ecf13f8ffa01e/lxml-4.8.0.tar.gz"
    sha256 "f63f62fc60e6228a4ca9abae28228f35e1bd3ce675013d1dfb828688d50c6e23"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"pretranslate", "-h"
    system bin/"podebug", "-h"
  end
end
