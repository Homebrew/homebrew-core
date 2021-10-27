class Task < Formula
  desc "Feature-rich console based todo list manager"
  homepage "https://taskwarrior.org/"
  url "https://github.com/GothenburgBitFactory/taskwarrior/releases/download/v2.6.1/task-2.6.1.tar.gz"
  sha256 "00aa6032b3d8379a5cfa29afb66d2b0703a69e3d1fea733d225d654dbcb0084f"
  license "MIT"
  head "https://github.com/GothenburgBitFactory/taskwarrior.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256                               arm64_monterey: "7c498b1efc7a8923f3778488f3e480e8eda87bd7265f21b78283e59d94599072"
    sha256                               arm64_big_sur:  "676b1d1ff1010a1ca30608b7092fb2b38abbea1c2a3241e6ff72d322b7fa48ce"
    sha256                               monterey:       "4bbf3cb74b79dd440809515a474daf1bbb5bab743c1333bbefa16569bd42e454"
    sha256                               big_sur:        "2d36d56302bd104719d07cf57c4af247ee72af3f1d817367c54a449a539ccb7d"
    sha256                               catalina:       "8e9d4141d866acf6deb820c9c10b498eb40234f93e7100ffa4b9419257fab8f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "50e2d1e85ec8408f214a12f5d7346d0e25e72e43ff4c6c17f6321fd6de6649f4"
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
