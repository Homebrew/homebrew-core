class Task < Formula
  desc "Feature-rich console based todo list manager"
  homepage "https://taskwarrior.org/"
  url "https://github.com/GothenburgBitFactory/taskwarrior/releases/download/v3.3.0/task-3.3.0.tar.gz"
  sha256 "7fd1e3571f673679758f001b5f44963eee59fd0d2cac887a5807cf2fd90856a1"
  license "MIT"
  head "https://github.com/GothenburgBitFactory/taskwarrior.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256                               arm64_sequoia: "1ef979eb7314c0a8ca74f96e7f935fba946b7128bd1614a1d7bf97d155901087"
    sha256                               arm64_sonoma:  "cfb3f2ca6cb41ffba4fea6adb21d8549e2d893cccbb7b0d8ffc53d160bdc41e8"
    sha256                               arm64_ventura: "7ccbcc8c40f100e4700f0926041946d45bafe6da725545fb9bf0be7be4392232"
    sha256                               sonoma:        "fab3bdfd1bfc3c86525b6b00c67c4bb1dc0168d8605711d333b59ca3fdd6ad4f"
    sha256                               ventura:       "b34afc2fc079048ff7f573e9b1509554171753dc511f6d71106eb1002d4d06ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6c7526a9f1bc1c91caed713777dc56860544fd67ecb78d40d7bfed24bc9d4763"
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
