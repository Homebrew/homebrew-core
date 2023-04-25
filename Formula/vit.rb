class Vit < Formula
  include Language::Python::Virtualenv

  desc "Full-screen terminal interface for Taskwarrior"
  homepage "https://taskwarrior.org/news/news.20140406.html"
  url "https://files.pythonhosted.org/packages/44/1c/e92432357d5dd26ad086e4a05ff066c0539e754fbe3dfdd78e0cb206964b/vit-2.3.0.tar.gz"
  sha256 "f3efd871c607f201251a5d1e0082e5e31e9161dde0df0c6d8b5a3447c76c87c6"
  license "MIT"
  head "https://github.com/vit-project/vit.git", branch: "2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dc14204fbfe13e997712377e10df24fc7670788bf86dbaa18b91b981c00a20a9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a3a3c84a83a1b6edc62a81dfb4d23142c96329651429579cd453ecc2b92891cb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5638ea75e260f5bd6c5bd9e023e4cca5c77b95847f9705a4c2bb6cc260b3b449"
    sha256 cellar: :any_skip_relocation, ventura:        "8de8b6c57f7f306b1b58ecbbd54b4cc54dbd8db7d25b73388a4685e8fa115740"
    sha256 cellar: :any_skip_relocation, monterey:       "d2af69dec0af1e44e2f8572a3f8e1f520d555e2f72181283a5205aed31bf3fda"
    sha256 cellar: :any_skip_relocation, big_sur:        "bf52cc4de5a6dda6ef2aada13f145fbf864a5cb31a40d701eec65ac4373bc68b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bf0cf914988224ef86de7447128bb1cce78e22207bad050cdfbe56fbae12d3b1"
  end

  depends_on "python@3.11"
  depends_on "task"

  resource "tasklib" do
    url "https://files.pythonhosted.org/packages/3e/50/3e876f39e31bad8783fd3fe117577cbf1dde836e161f8446631bde71aeb4/tasklib-2.5.1.tar.gz"
    sha256 "5ccd731b52636dd10457a8b8d858cb0d026ffaab1e3e751baf791bf803e37d7b"
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
