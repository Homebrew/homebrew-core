class Task < Formula
  desc "Feature-rich console based todo list manager"
  homepage "https://taskwarrior.org/"
  url "https://github.com/GothenburgBitFactory/taskwarrior/releases/download/v3.4.1/task-3.4.1.tar.gz"
  sha256 "23eb60f73e42f16111cc3912b44ee12be6768860a2db2a9c6a47f8ac4786bac3"
  license "MIT"
  head "https://github.com/GothenburgBitFactory/taskwarrior.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256                               arm64_sequoia: "e9f5596f4410829165b5884d30c10c784ba5e096ca118ec9739119b678d6ec10"
    sha256                               arm64_sonoma:  "0148f717868777b7ebc63d40e8800a38042a12a1717c8cfa22c8e74e47c6a9ef"
    sha256                               arm64_ventura: "a6c60113d44922bdba309d58bb265ad1cec5109d1b5ab3b4f43e69f952464397"
    sha256                               sonoma:        "2f4aafa45935096b86b0e83ca5734fd0014583db767868dae81c436ddec82b0c"
    sha256                               ventura:       "7a9f8b67f6ed92259cd1ba03dc22c1954bf96ec684bebbc76d2fd060392621bc"
    sha256                               arm64_linux:   "960048db5e01d5af8b047ec4172614a7bbf410b02bca9f96874d540b88fbae90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "03fbb2a6f7dc6876e237cd114f2fc6cbd854fdd238d194e932a6cc8f50e1c9e3"
  end

  depends_on "cmake" => :build
  depends_on "corrosion" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "linux-headers@5.15" => :build
    depends_on "readline"
    depends_on "util-linux"
  end

  conflicts_with "go-task", because: "both install `task` binaries"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    bash_completion.install "scripts/bash/task.sh"
    zsh_completion.install "scripts/zsh/_task"
    fish_completion.install "scripts/fish/task.fish"
  end

  test do
    touch testpath/".taskrc"
    system bin/"task", "add", "Write", "a", "test"
    assert_match "Write a test", shell_output("#{bin}/task list")
  end
end
