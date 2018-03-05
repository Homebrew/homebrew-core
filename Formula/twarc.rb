class Twarc < Formula
  include Language::Python::Virtualenv

  desc "Command-line tool and Python library for archiving Twitter JSON"
  homepage "https://github.com/DocNow/twarc"
  url "https://files.pythonhosted.org/packages/61/6f/1a8291891d6956aba611347bf0de5424b01a436d5939ebd924a19f0bc2f5/twarc-1.4.0.tar.gz"
  sha256 "844ee2a3816074e4dfe2edd562713c2dbead88779b43fb36ea8b186be79e62a1"

  bottle do
    cellar :any_skip_relocation
    sha256 "6b27d61dc5d5908e281a08cfbd6dbe60372e279d66dc1dce1cf50cd12f30b931" => :high_sierra
    sha256 "a480182fe6e8691cf77513c6fe96af602dc459b221687e1a9bae556cc8cc6723" => :sierra
    sha256 "477df59ca1134c841f7856c657d7ffb330cafbe8202c519c2b8968221ecf7f07" => :el_capitan
  end

  depends_on "python@2" if MacOS.version <= :snow_leopard

  def install
    venv = virtualenv_create(libexec)
    system libexec/"bin/pip", "install", "-v", "--no-binary", ":all:",
                              "--ignore-installed", buildpath
    system libexec/"bin/pip", "uninstall", "-y", "twarc"
    venv.pip_install_and_link buildpath
  end

  test do
    assert_equal "usage: twarc [-h] [--log LOG] [--consumer_key CONSUMER_KEY]",
                 shell_output("#{bin}/twarc -h").chomp.split("\n").first
  end
end
