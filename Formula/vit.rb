class Vit < Formula
  include Language::Python::Virtualenv

  desc "Full-screen terminal interface for Taskwarrior"
  homepage "https://taskwarrior.org/news/news.20140406.html"
  url "https://files.pythonhosted.org/packages/55/47/6d9a86e0646c0f65bb5be565c05699d11722d42cb2dd71c31380fc52aa73/vit-2.1.0.tar.gz"
  sha256 "fd34f0b827953dfdecdc39f8416d41c50c24576c33a512a047a71c1263eb3e0f"
  license "MIT"
  revision 1
  head "https://github.com/vit-project/vit.git", branch: "2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3fb8beae350a46c57b5e40940f5223043eb171dd7a1bcc4b9ef40320c2202571"
    sha256 cellar: :any_skip_relocation, big_sur:       "5fedd66cd3ea0e7b6f5cbb4e285b65c085a6b041190d42afa3ddbc4a1aa18f13"
    sha256 cellar: :any_skip_relocation, catalina:      "17221b4deacb1ca0e63fc7949a06298dfe9d64c9a672a9974f63f4dc15473404"
    sha256 cellar: :any_skip_relocation, mojave:        "d65ce3abf2f776a8baee233c618b543c2f806e48cfd343cc4d3febc9947f71b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f071f296dda7703215badc37478d56c9cec45b9e592293e9b71741f5ee36c844"
  end

  depends_on "python@3.10"
  depends_on "task"

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/e3/8e/1cde9d002f48a940b9d9d38820aaf444b229450c0854bdf15305ce4a3d1a/pytz-2021.3.tar.gz"
    sha256 "acad2d8b20a1af07d4e4c9d2e9285c5ed9104354062f275f3fcd88dcef4f1326"
  end

  resource "tasklib" do
    url "https://files.pythonhosted.org/packages/bd/cd/419a4a0db43d579b1d883ad081cf321feb97ba2afe78d875a9a148b75331/tasklib-2.4.3.tar.gz"
    sha256 "b523bc12893d26c8173a6b8d84b16259c9a9c5acaaf8932bc018117f907b3bc5"
  end

  resource "tzlocal" do
    url "https://files.pythonhosted.org/packages/89/e7/5fc01b31d9df0b914d5bbbea6f5d80ff76c6b5cf11bf23a8beca8407a0f1/tzlocal-3.0.tar.gz"
    sha256 "f4e6e36db50499e0d92f79b67361041f048e2609d166e93456b50746dc4aef12"
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
