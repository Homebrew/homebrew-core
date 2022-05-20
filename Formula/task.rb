class Task < Formula
  desc "Feature-rich console based todo list manager"
  homepage "https://taskwarrior.org/"
  url "https://github.com/GothenburgBitFactory/taskwarrior/releases/download/v2.6.2/task-2.6.2.tar.gz"
  sha256 "b1d3a7f000cd0fd60640670064e0e001613c9e1cb2242b9b3a9066c78862cfec"
  license "MIT"
  head "https://github.com/GothenburgBitFactory/taskwarrior.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256                               arm64_monterey: "a1a3c706322405709ad4d89005abf423ae6252255b1f25857c68112d98f0cfc8"
    sha256                               arm64_big_sur:  "4bfece330fa1a6951f49ce2539eee0a44cee4ac71e5f2d52f52cc98300cf4f6c"
    sha256                               monterey:       "08ad2ecfcdb93b578bbc296c874c139225bd7a09b0130432232830a5cb6a916d"
    sha256                               big_sur:        "5d7f4c9ab31bd5f2daa9b90e46c01fc75fa75c5dd59f53d71c470ca3453b4d18"
    sha256                               catalina:       "d387254a93560ad965cf29753847fc830057f655361ba9f0b9e31c53843b3768"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e01eea1f420752a719c38be2e618506fa22b9c7b83d23ef7606d9e2c87f48257"
  end

  depends_on "cmake" => :build
  depends_on "gnutls"

  on_linux do
    depends_on "gcc"
    depends_on "linux-headers@4.4"
    depends_on "readline"
    depends_on "util-linux"
  end

  fails_with gcc: "5"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
    bash_completion.install "scripts/bash/task.sh"
    zsh_completion.install "scripts/zsh/_task"
    fish_completion.install "scripts/fish/task.fish"
  end

  test do
    touch testpath/".taskrc"
    system "#{bin}/task", "add", "Write", "a", "test"
    assert_match "Write a test", shell_output("#{bin}/task list")
  end
end
