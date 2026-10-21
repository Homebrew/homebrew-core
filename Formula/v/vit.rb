class Vit < Formula
  include Language::Python::Virtualenv

  desc "Full-screen terminal interface for Taskwarrior"
  homepage "https://github.com/vit-project/vit"
  url "https://files.pythonhosted.org/packages/1c/11/5a62bb49c3f5086d0e3eb85cb66eae9c2cc49123b9eb9dadfa032ea9c67a/vit-2.3.4.tar.gz"
  sha256 "346a210aa0de754cf7adaf73723bf7d2cc8ee754eeb785eb18370d33f74e5ce2"
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

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/f6/cc/6253133b5bb138fc3306cebfbda2c520f545d36b5be2c7255cc528bb45d6/typing_extensions-4.16.0.tar.gz"
    sha256 "dc983d19a509c94dba722ee6abd33940f7c05a89e243c47e907eb4db6f1a43e5"
  end

  resource "urwid" do
    url "https://files.pythonhosted.org/packages/3a/df/eb5dcbdf1638c38618096382b4a30b0423ed7d2aac97fd9469b51d6de43f/urwid-4.2.5.tar.gz"
    sha256 "a1fea3a551953fae4e6b727536334233bbb8b88c45230bc91d9751b402a8c16d"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/f0/b4/7830542634bb2d3e62aa3b586a72d5b3b6c91c3168929e7000ef3fed041d/wcwidth-0.9.2.tar.gz"
    sha256 "ae0ef90b90f6af38b54f1fe6d58662ec33b3cb4b8391958a62416d654231727b"
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
