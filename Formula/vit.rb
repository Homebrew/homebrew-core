class Vit < Formula
  include Language::Python::Virtualenv

  desc "Full-screen terminal interface for Taskwarrior"
  homepage "https://taskwarrior.org/news/news.20140406.html"
  url "https://files.pythonhosted.org/packages/81/30/4fb1a37f4cfbac8df781b378526c8ea91d21912164a416a4f7c0cb3fe1c8/vit-2.2.0.tar.gz"
  sha256 "e866c8739822b9e73152ab30c9a009c3aef947533c06f7a5cb244d15c4ea296f"
  license "MIT"
  head "https://github.com/vit-project/vit.git", branch: "2.x"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6a9ec60c1bea0b80ec4a455e3947af84a84ac93eec8b76150904bad79685dd8f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "92a82feed66d18761246eed767e5bcefe18cbe17c36f4104e245e9a8fc6ccc9f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b9a265b17cc76cb95b5852d458bc5996af619f85676d8b86ae69888e93d78f41"
    sha256 cellar: :any_skip_relocation, monterey:       "7593aad3669004423effee2c0a1e27ea2e64e1763846f70054df85bf4d7b763e"
    sha256 cellar: :any_skip_relocation, big_sur:        "8f0526731e932d972914287016dac6953abba079b17da0e8dc4900a75ec3a848"
    sha256 cellar: :any_skip_relocation, catalina:       "fa0b151ea6e6ff4c747d77792843a6e5564318aae35afbd5a6fbbebd83920901"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0b268d1e61ed6854790d059dcebcd02ee54fab57bdccbedd113afef01ba71bd0"
  end

  depends_on "python@3.11"
  depends_on "task"

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/76/63/1be349ff0a44e4795d9712cc0b2d806f5e063d4d34631b71b832fac715a8/pytz-2022.6.tar.gz"
    sha256 "e89512406b793ca39f5971bc999cc538ce125c0e51c27941bef4568b460095e2"
  end

  resource "pytz-deprecation-shim" do
    url "https://files.pythonhosted.org/packages/94/f0/909f94fea74759654390a3e1a9e4e185b6cd9aa810e533e3586f39da3097/pytz_deprecation_shim-0.1.0.post0.tar.gz"
    sha256 "af097bae1b616dde5c5744441e2ddc69e74dfdcb0c263129610d85b87445a59d"
  end

  resource "tasklib" do
    url "https://files.pythonhosted.org/packages/bd/cd/419a4a0db43d579b1d883ad081cf321feb97ba2afe78d875a9a148b75331/tasklib-2.4.3.tar.gz"
    sha256 "b523bc12893d26c8173a6b8d84b16259c9a9c5acaaf8932bc018117f907b3bc5"
  end

  resource "tzdata" do
    url "https://files.pythonhosted.org/packages/5e/9f/63f7187ffd6d01dd5b5255b8c0b1c4f05ecfe79d940e0a243a6198071832/tzdata-2022.6.tar.gz"
    sha256 "91f11db4503385928c15598c98573e3af07e7229181bee5375bd30f1695ddcae"
  end

  resource "tzlocal" do
    url "https://files.pythonhosted.org/packages/7d/b9/164d5f510e0547ae92280d0ca4a90407a15625901afbb9f57a19d9acd9eb/tzlocal-4.2.tar.gz"
    sha256 "ee5842fa3a795f023514ac2d801c4a81d1743bbe642e3940143326b3a00addd7"
  end

  resource "urwid" do
    url "https://files.pythonhosted.org/packages/94/3f/e3010f4a11c08a5690540f7ebd0b0d251cc8a456895b7e49be201f73540c/urwid-2.1.2.tar.gz"
    sha256 "588bee9c1cb208d0906a9f73c613d2bd32c3ed3702012f51efe318a3f2127eae"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/".vit").mkpath
    touch testpath/".vit/config.ini"
    touch testpath/".taskrc"

    require "pty"
    PTY.spawn(bin/"vit") do |_stdout, _stdin, pid|
      sleep 3
      Process.kill "TERM", pid
    end
    assert_predicate testpath/".task", :exist?
  end
end
