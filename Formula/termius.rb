class Termius < Formula
  include Language::Python::Virtualenv

  desc "CLI tool for termius.com (aka serverauditor.com)"
  homepage "https://termius.com"
  url "https://github.com/Crystalnix/termius-cli/archive/v1.2.1.tar.gz"
  sha256 "52722e29e9d9a480f4a862ae944ccac180d9829f0792b7ee7209ccbe1600df93"
  head "https://github.com/Crystalnix/termius-cli.git", :branch => "develop"

  bottle do
    cellar :any
    sha256 "bfba0c2494ee4bd8ae6f0b700e5634c918f8bea39617b0c4fbd58bbd5798dbde" => :sierra
    sha256 "dc860ea95472c733531ae459d18a59c6f41444418b440f5335481e90290bbd48" => :el_capitan
    sha256 "88b495045ff092c90c235110f8fc7c563e6ca0c97ad2514b0f80ee4582f4a5f0" => :yosemite
  end

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "openssl"
  depends_on "bash-completion" => :recommended
  depends_on "zsh-completions" => :recommended

  def install
    venv = virtualenv_create(libexec)
    system libexec/"bin/pip", "install", "-v", "--no-binary", ":all:",
                              "--ignore-installed", buildpath
    system libexec/"bin/pip", "uninstall", "-y", "termius"
    venv.pip_install_and_link buildpath

    bash_completion.install "contrib/completion/bash/termius"
    zsh_completion.install "contrib/completion/zsh/_termius"
  end

  test do
    system "#{bin}/termius", "host", "--address", "localhost", "-L", "test_host"
    system "#{bin}/termius", "host", "--delete", "test_host"
  end
end
