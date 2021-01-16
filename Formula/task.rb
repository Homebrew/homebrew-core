class Task < Formula
  desc "Feature-rich console based todo list manager"
  homepage "https://taskwarrior.org/"
  url "https://github.com/GothenburgBitFactory/taskwarrior/releases/download/v2.5.3/task-2.5.3.tar.gz"
  sha256 "7243d75e0911d9e2c9119ad94a61a87f041e4053e197f7280c42410aa1ee963b"
  license "MIT"
  head "https://github.com/GothenburgBitFactory/taskwarrior.git", branch: "2.6.0", shallow: false

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 "13cbe306b15eda0b1a2edd707f3c1e2a18759bfa2613a4a5909f5945c7ac367c" => :big_sur
    sha256 "188f5f1a5dda2cff99e1adf0be22980f5cfa72b3dbffdbef8d9648e65ce23641" => :arm64_big_sur
    sha256 "6b15062cfa4e67ba49cd6bcb88a1be453e49b86f4ab680acb171fe98e01e256b" => :catalina
    sha256 "8ea578cb22e2a379478111ca18c735482c264a46d3733a866cfc959ce344c4f4" => :mojave
  end

  depends_on "cmake" => :build
  depends_on "gnutls"

  on_linux do
    depends_on "linux-headers"
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
