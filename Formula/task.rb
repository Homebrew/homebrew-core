class Task < Formula
  desc "Feature-rich console based todo list manager"
  homepage "https://taskwarrior.org/"
  url "https://github.com/GothenburgBitFactory/taskwarrior/releases/download/v2.5.3/task-2.5.3.tar.gz"
  sha256 "7243d75e0911d9e2c9119ad94a61a87f041e4053e197f7280c42410aa1ee963b"
  license "MIT"
  revision 1
  head "https://github.com/GothenburgBitFactory/taskwarrior.git", branch: "2.6.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_big_sur: "f6cc717032d0b9fb61f160e18d0d529aaf140109493b749af8df0b67d9cfbeb2"
    sha256 big_sur:       "6e39bda4bf09836a2c8957024008fb23c568d1f1793ec0cf75986616b1c6702c"
    sha256 catalina:      "26985b801af3eb7ce1edb1a4294dd9258c869be2fedc694856bf8c1781dfdcd2"
    sha256 mojave:        "8d4d6b2c44aa2d813bb34314f367679d3677ba60e264e06b235a094ac39f5b66"
    sha256 x86_64_linux:  "e3db87ee3f43f83b61183ddae86f5149c6838dd32097dfe5e06c94441914dc3a"
  end

  depends_on "cmake" => :build
  depends_on "gnutls"

  on_linux do
    depends_on "linux-headers@4.4"
    depends_on "readline"
    depends_on "util-linux"
  end

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
