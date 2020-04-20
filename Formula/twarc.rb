class Twarc < Formula
  include Language::Python::Virtualenv

  desc "Command-line tool and Python library for archiving Twitter JSON"
  homepage "https://github.com/DocNow/twarc"
  url "https://files.pythonhosted.org/packages/d9/e7/d65758f2cb7267b2fb8a905b53987ce4f21240a40d0317d8d085c83875a8/twarc-1.8.3.tar.gz"
  sha256 "7b1d9f418152e00ebd709a8a64b12a1b0b102823409dc4524288173e36b948f1"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "00484a55996a2b70204315c4b44ad2b089f7a2fe0f0c17817a561d4da8e4bc6e" => :catalina
    sha256 "65ed65ea7ff933bf7249737c006e395e466af70d8a93c35149caab8bfb03f025" => :mojave
    sha256 "625abc0bc29a64e4e5cf148ef20044f0c0ab2b10d07d9cf67da35be8f9a0bc30" => :high_sierra
  end

  depends_on "python@3.8"

  def install
    venv = virtualenv_create(libexec, Formula["python@3.8"].opt_bin/"python3")
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
