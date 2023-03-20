class Task < Formula
  desc "Feature-rich console based todo list manager"
  homepage "https://taskwarrior.org/"
  url "https://github.com/GothenburgBitFactory/taskwarrior/releases/download/v2.6.2/task-2.6.2.tar.gz"
  sha256 "b1d3a7f000cd0fd60640670064e0e001613c9e1cb2242b9b3a9066c78862cfec"
  license "MIT"
  revision 1
  head "https://github.com/GothenburgBitFactory/taskwarrior.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end
  bottle do
    rebuild 1
    sha256                               arm64_ventura:  "11ca4562ebc4ea8273f0cab7ef18ec41980c83a373f4b6369b898ee19bea15eb"
    sha256                               arm64_monterey: "2c1d0eb0f0522bbf4cdd0dea43c394afaceec873d58c609b211f6450cd09421d"
    sha256                               arm64_big_sur:  "c2342e1543ea07eba65ab7bef36e25a0e463e6baeab6e562bbcb4a572faa89e7"
    sha256                               ventura:        "ffde36684ca7b6ed1e01327fd2aeaadb588aeb06125065cd8781d4b5ea630374"
    sha256                               monterey:       "72cc6c37f541104645ff0d7f952abc7e3acf80cf2e91dd32eceecb80502baf53"
    sha256                               big_sur:        "7671bf2e4b715cffd7895b97ff049295bea6faee8f4028c7c8c78be2f4ab8c66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "53cb397182b40cbad438aefbe4fb38e505f0eac4b2999dd38ffbb8aad3d12f86"
  end

  depends_on "cmake" => :build
  depends_on "gnutls"

  on_linux do
    depends_on "linux-headers@5.15" => :build
    depends_on "readline"
    depends_on "util-linux"
  end

  conflicts_with "go-task", because: "both install `task` binaries"

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
