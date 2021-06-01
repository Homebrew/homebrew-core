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
    sha256                               arm64_big_sur: "c0078f45218be9eda3843a45cd8a804e9268f1b57d6deacb4508970182fa7aa4"
    sha256                               big_sur:       "dfce309ab06701933c0bc0f7d6d1c7ecbe4dd29e5b18accd9ba665fb99ba652d"
    sha256                               catalina:      "29ebd088d472e31ae57e83bd09a2eafc76a38ebb309cd6277939243a5bfbd4ad"
    sha256                               mojave:        "52bd72001be7ba3ebaf730dac5506fcb4f070cc756f2d06924b6997a689cf5d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7c6f580418109f7e31066b3224c11c50f5eb90649a532d095baf9fbef00cecfa"
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
