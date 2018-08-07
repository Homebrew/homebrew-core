class Twarc < Formula
  include Language::Python::Virtualenv

  desc "Command-line tool and Python library for archiving Twitter JSON"
  homepage "https://github.com/DocNow/twarc"
  url "https://files.pythonhosted.org/packages/d9/ac/e3728e1b2ea9c2727ac06f663615b6d70309f9b4ae58906ef40a6a126dfd/twarc-1.5.1.tar.gz"
  sha256 "76260b09e8a7af6d5efc9c7d29ac491df2daafc2937b74590b6e75988d902d68"

  bottle do
    cellar :any_skip_relocation
    sha256 "788453090806759f5308e9bbd4846fa86b5c5a952ae36953adf107302ad35908" => :high_sierra
    sha256 "e7e283eb224661309d138ebb54a86572d9382d0fc9c8ec2f1b4ac56cff3a8fec" => :sierra
    sha256 "54abdcab9ff7e5d07fd65aa4bd6c144ef2d9e9666300d45a02e8c8ef393b4efa" => :el_capitan
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
