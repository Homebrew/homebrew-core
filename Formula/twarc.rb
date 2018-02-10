class Twarc < Formula
  include Language::Python::Virtualenv

  desc "Command-line tool and Python library for archiving Twitter JSON"
  homepage "https://github.com/DocNow/twarc"
  url "https://files.pythonhosted.org/packages/af/65/d639c26d4308f589ac29ba17fa000678d60494535721bb5b0738feb5173a/twarc-1.3.6.tar.gz"
  sha256 "570ab09be308ce1617bce6c3845626932087d205a41e785ef2f2b41c0fdb175c"

  bottle do
    cellar :any_skip_relocation
    sha256 "b7d8b6f70e358576b1393bd2ca6692ce0e6a07d47aeb04f4680025af45af26c3" => :high_sierra
    sha256 "fb7b76b8b1d3501730195610817863833b8d69af024541ee53c7c427fb0720e5" => :sierra
    sha256 "0e37452cb097ba9a487075f291a3f3ef062e1b397ada7020540a841619b64336" => :el_capitan
  end

  depends_on "python" if MacOS.version <= :snow_leopard

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
