class Vit < Formula
  include Language::Python::Virtualenv

  desc "Full-screen terminal interface for Taskwarrior"
  homepage "https://github.com/vit-project/vit"
  url "https://files.pythonhosted.org/packages/83/91/ff4440f0c87ffe8ff73176bf165925e364b938729ba9eb7a9090ae229129/vit-2.3.3.tar.gz"
  sha256 "fa5ad719f868078cf92169094d73089b718654f7cd18ef65501dee153c7c8436"
  license "MIT"
  head "https://github.com/vit-project/vit.git", branch: "2.x"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "e690473bf1990d4aa5181c8e9e4a7656b3d6c83dbc1572c79f84b039655095a5"
  end

  depends_on "python@3.14"
  depends_on "task"

  resource "tasklib" do
    url "https://files.pythonhosted.org/packages/3e/50/3e876f39e31bad8783fd3fe117577cbf1dde836e161f8446631bde71aeb4/tasklib-2.5.1.tar.gz"
    sha256 "5ccd731b52636dd10457a8b8d858cb0d026ffaab1e3e751baf791bf803e37d7b"
  end

  resource "urwid" do
    url "https://files.pythonhosted.org/packages/bb/d3/09683323e2290732a39dc92ca5031d5e5ddda56f8d236f885a400535b29a/urwid-3.0.3.tar.gz"
    sha256 "300804dd568cda5aa1c5b204227bd0cfe7a62cef2d00987c5eb2e4e64294ed9b"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/24/30/6b0809f4510673dc723187aeaf24c7f5459922d01e2f794277a3dfb90345/wcwidth-0.2.14.tar.gz"
    sha256 "4d478375d31bc5395a3c55c40ccdf3354688364cd61c4f6adacaa9215d0b3605"
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
      sleep 10 if OS.mac? && Hardware::CPU.intel?
      Process.kill "TERM", pid
    end
    assert_path_exists testpath/".task"
  end
end
