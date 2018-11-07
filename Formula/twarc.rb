class Twarc < Formula
  include Language::Python::Virtualenv

  desc "Command-line tool and Python library for archiving Twitter JSON"
  homepage "https://github.com/DocNow/twarc"
  url "https://files.pythonhosted.org/packages/e1/f2/2d79badd5fab00826d5fb2a66b0d1923933ef937338edbdbdd01ae3f5181/twarc-1.6.1.tar.gz"
  sha256 "2dc79f58859ceb609a139ae90296b9eff754a2219a0b3faa6cd794d2faf6c18b"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "efafb2a333928c22287dcdb2bc5f533ba974f06301cc66786a2f5d1281004510" => :mojave
    sha256 "cc8a3acf5a667b44b9bab745f1169663a4e3bf1a76d9f0453be3c5140a63794a" => :high_sierra
    sha256 "a7bd954c8c173983e004079fba76021d9d19708c62ecd2da9d049fa518c959ac" => :sierra
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
