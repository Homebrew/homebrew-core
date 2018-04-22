class Twarc < Formula
  include Language::Python::Virtualenv

  desc "Command-line tool and Python library for archiving Twitter JSON"
  homepage "https://github.com/DocNow/twarc"
  url "https://files.pythonhosted.org/packages/59/48/0788dc91ff1ba1ced9c03243f2948cc444c6af95cfc0a469ecf30ae50b40/twarc-1.4.3.tar.gz"
  sha256 "49f129a439736e86cba162b520bdbd288c93cffdf23764377431cc435bb17a86"

  bottle do
    cellar :any_skip_relocation
    sha256 "4e149bb379d2b5269675abcd20cc1f8eb78a9bab2c161ffff741f91bc15453c1" => :high_sierra
    sha256 "e37b8a29465d9748e8fcd3326406dd6ef7312d1d5624a1e165c54d47a7d54e8e" => :sierra
    sha256 "320ec51af4f67fd26bc09ddf8962f50c7edcc432c5489911e130ce6617b7d4ee" => :el_capitan
  end

  depends_on "python@2"

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
