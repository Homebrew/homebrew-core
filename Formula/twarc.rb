class Twarc < Formula
  include Language::Python::Virtualenv

  desc "Command-line tool and Python library for archiving Twitter JSON"
  homepage "https://github.com/DocNow/twarc"
  url "https://files.pythonhosted.org/packages/59/48/0788dc91ff1ba1ced9c03243f2948cc444c6af95cfc0a469ecf30ae50b40/twarc-1.4.3.tar.gz"
  sha256 "49f129a439736e86cba162b520bdbd288c93cffdf23764377431cc435bb17a86"

  bottle do
    cellar :any_skip_relocation
    sha256 "dd2f9d4a1040d12968b574535b3565c81c44e1709de8925cebaddbc11b6f4951" => :high_sierra
    sha256 "052a6cd6173ed0f2311eb9f49445cc2be1c352e9e31cb2ecefd856ccc5043d32" => :sierra
    sha256 "0eed3610cb3e468d44a19c6cf17a58462795429635fe143185dde3aa84d88189" => :el_capitan
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
