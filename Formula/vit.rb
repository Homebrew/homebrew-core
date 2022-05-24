class Vit < Formula
  include Language::Python::Virtualenv

  desc "Full-screen terminal interface for Taskwarrior"
  homepage "https://taskwarrior.org/news/news.20140406.html"
  url "https://files.pythonhosted.org/packages/81/30/4fb1a37f4cfbac8df781b378526c8ea91d21912164a416a4f7c0cb3fe1c8/vit-2.2.0.tar.gz"
  sha256 "e866c8739822b9e73152ab30c9a009c3aef947533c06f7a5cb244d15c4ea296f"
  license "MIT"
  head "https://github.com/vit-project/vit.git", branch: "2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5b1eaabfb96281eae1bfba00b3ba8487fd376e1227f5aacc609695fb50d41226"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "398f36315d72fd5bfb174932fc4055196af6214f7858ff4b487b2bc3ddea58e3"
    sha256 cellar: :any_skip_relocation, monterey:       "15ed7af78b38752df9117fdf3fe0f4b5499121c8bc99f6dc8640b438c7d2c2d0"
    sha256 cellar: :any_skip_relocation, big_sur:        "3b796fe7b3bf2dbe817a6f2c362f98618727ea0cdf2ae83da9d5f8677d1fc106"
    sha256 cellar: :any_skip_relocation, catalina:       "039df86beca6eeb7d6b897d76e1ced3ed9aae20ad2ebd404dba4cb6461dd13f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "79c669f66f438b6f6fce0cea91131cc0967863ed04dfaed1b840486c11836653"
  end

  depends_on "python@3.10"
  depends_on "task"

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/2f/5f/a0f653311adff905bbcaa6d3dfaf97edcf4d26138393c6ccd37a484851fb/pytz-2022.1.tar.gz"
    sha256 "1e760e2fe6a8163bc0b3d9a19c4f84342afa0a2affebfaa84b01b978a02ecaa7"
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
    url "https://files.pythonhosted.org/packages/df/c7/2d8ea31840794fb341bc2c2ea72bf1bd16bd778bd8c0d7c9e1e5f9df1de3/tzdata-2022.1.tar.gz"
    sha256 "8b536a8ec63dc0751342b3984193a3118f8fca2afe25752bb9b7fffd398552d3"
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
