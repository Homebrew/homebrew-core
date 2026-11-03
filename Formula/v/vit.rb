class Vit < Formula
  include Language::Python::Virtualenv

  desc "Full-screen terminal interface for Taskwarrior"
  homepage "https://github.com/vit-project/vit"
  url "https://files.pythonhosted.org/packages/7d/79/9f6482915a4204458816e2cfd18d8c9a907e13c2168a569e8b1de245d84f/vit-2.3.5.tar.gz"
  sha256 "f0994d3097af290478b08abb11e6de6ef8461d5fc317bd95fd4a729a9dd57d1e"
  license "MIT"
  head "https://github.com/vit-project/vit.git", branch: "2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d813a5b4faee80010eacde0c21f3aade6168021f4df74dff18b8a2a23784debe"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "df0d8d3782c38c4c2f12ac57d86c431deb5b0074222d52d75b39b7f0e4b113fd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "af8ca56b40c28f82936cc701d4d3542908f5ce041070b011581841df4c44890a"
    sha256 cellar: :any,                 arm64_linux:       "adbc3a0a98f2e1f502ed61d7ca3289da9edba325d815ed0634685d9fecd5183e"
    sha256 cellar: :any,                 x86_64_linux:      "06ea33004dbe2174f1712c618bb647d7925820120a5b6cbd0be54685a49aa239"
  end

  depends_on "python@3.15"
  depends_on "task"

  resource "tasklib" do
    url "https://files.pythonhosted.org/packages/3e/50/3e876f39e31bad8783fd3fe117577cbf1dde836e161f8446631bde71aeb4/tasklib-2.5.1.tar.gz"
    sha256 "5ccd731b52636dd10457a8b8d858cb0d026ffaab1e3e751baf791bf803e37d7b"
  end

  resource "urwid" do
    url "https://files.pythonhosted.org/packages/ee/16/8d5b79d05dc960ec6527bb58c773b1bfe68ac90c8ee551771765e87a3971/urwid-5.0.1.tar.gz"
    sha256 "338d6a0f8e7c58c205dd823b9c777b0f7a290c7ea661fcf81b12c42e4072ca24"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/ea/01/e5ac23733628a6bbb91913a765fcf55ee8070d8d991bc88fdaaf805052c7/wcwidth-0.9.4.tar.gz"
    sha256 "fd8d57d3cdfe570e3265c8fab1885c24e34ef40889c0759c0c304a19e9835954"
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
    assert_path_exists testpath/".task"
  end
end
