class Twarc < Formula
  include Language::Python::Virtualenv

  desc "Command-line tool and Python library for archiving Twitter JSON"
  homepage "https://github.com/DocNow/twarc"
  url "https://files.pythonhosted.org/packages/52/ba/17184ea480f7674109f8f97ac14cdc6220db0ee19d1543c3f5ec2cd9ff2a/twarc-1.7.3.tar.gz"
  sha256 "80b03740b38911d73a988ab3a0d44c3c542b7cdbe416a10439c4fe883e6b2715"

  bottle do
    cellar :any_skip_relocation
    sha256 "3f247f84bdfefa5856eea5a7e8e81f0acd1456bf68ab87fd0f2afb612a940c22" => :mojave
    sha256 "afe2c1fb2379f1d32c6e004823310908850394ed1af33f622afd6165b4914c5e" => :high_sierra
    sha256 "fd651808b565af0bbd66744e1452ce6675c851cc6940b5ce3a4dca894e594fce" => :sierra
  end

  depends_on "python"

  def install
    venv = virtualenv_create(libexec, "python3")
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
