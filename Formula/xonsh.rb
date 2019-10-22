class Xonsh < Formula
  include Language::Python::Virtualenv

  desc "Python-ish, BASHwards-compatible shell language and command prompt"
  homepage "https://xon.sh/"
  url "https://github.com/xonsh/xonsh/archive/0.9.13.tar.gz"
  sha256 "21b9c81377c3be04bdf72f0eca2370a3c3ad7b050683362bc52ec84085cdebd2"
  head "https://github.com/xonsh/xonsh.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "10ee5748da75f7eeb67ad4c18d5cb068aedb4900b99817e6bc21abe0f1ad1ccb" => :catalina
    sha256 "61b50ab167ff40a6f9e047e08ba4e282fa2856bcf2cec60c7fd2d0de5e89d6a7" => :mojave
    sha256 "245117ead07c8301e7ca7472e9c15542f001885101bb5b9013d9e8bf43e56d39" => :high_sierra
  end

  depends_on "python"

  # Resources based on `pip3 install xonsh[ptk,pygments,proctitle]`
  # See https://xon.sh/osx.html#dependencies

  resource "prompt_toolkit" do
    url "https://files.pythonhosted.org/packages/0c/37/7ad3bf3c6dbe96facf9927ddf066fdafa0f86766237cff32c3c7355d3b7c/prompt_toolkit-2.0.10.tar.gz"
    sha256 "f15af68f66e664eaa559d4ac8a928111eebd5feda0c11738b5998045224829db"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/7e/ae/26808275fc76bf2832deb10d3a3ed3107bc4de01b85dcccbe525f2cd6d1e/Pygments-2.4.2.tar.gz"
    sha256 "881c4c157e45f30af185c1ffe8d549d48ac9127433f2c380c24b84572ad66297"
  end

  resource "setproctitle" do
    url "https://files.pythonhosted.org/packages/5a/0d/dc0d2234aacba6cf1a729964383e3452c52096dc695581248b548786f2b3/setproctitle-1.1.10.tar.gz"
    sha256 "6283b7a58477dd8478fbb9e76defb37968ee4ba47b05ec1c053cb39638bd7398"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/dd/bf/4138e7bfb757de47d1f4b6994648ec67a51efe58fa907c1e11e350cddfca/six-1.12.0.tar.gz"
    sha256 "d16a0141ec1a18405cd4ce8b4613101da75da0e9a7aec5bdd4fa804d0e0eba73"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/55/11/e4a2bb08bb450fdbd42cc709dd40de4ed2c472cf0ccb9e64af22279c5495/wcwidth-0.1.7.tar.gz"
    sha256 "3df37372226d6e63e1b1e1eda15c594bca98a22d33a23832a90998faa96bc65e"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "4", shell_output("#{bin}/xonsh -c 2+2")
  end
end
