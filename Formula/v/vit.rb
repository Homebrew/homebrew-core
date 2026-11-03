class Vit < Formula
  include Language::Python::Virtualenv

  desc "Full-screen terminal interface for Taskwarrior"
  homepage "https://github.com/vit-project/vit"
  url "https://files.pythonhosted.org/packages/7d/79/9f6482915a4204458816e2cfd18d8c9a907e13c2168a569e8b1de245d84f/vit-2.3.5.tar.gz"
  sha256 "f0994d3097af290478b08abb11e6de6ef8461d5fc317bd95fd4a729a9dd57d1e"
  license "MIT"
  head "https://github.com/vit-project/vit.git", branch: "2.x"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "bee3612b4ed1167592908b1de8c0fc09fb9ba357b7e19ebc19ff6f15bb6962e4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b273f35880db79cc22214d7101753422699edd6ac2be2ba1df48735a36c907b7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "dd2da7be6f33595cb21195eac868e2c1870d1bf1fc6a22d2a8b75a5255220fac"
    sha256 cellar: :any,                 arm64_linux:       "6d456ba23d3b36ec1877312e432b867ada08a5c492e8b0f28146ddc1e7201a31"
    sha256 cellar: :any,                 x86_64_linux:      "844022406a96d6e95e26da3e217dcc64a4530f4c801a74db2df4d3b3b91a1edf"
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
