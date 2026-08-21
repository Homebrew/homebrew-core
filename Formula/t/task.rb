class Task < Formula
  desc "Feature-rich console based todo list manager"
  homepage "https://taskwarrior.org/"
  url "https://github.com/GothenburgBitFactory/taskwarrior/releases/download/v3.5.0/task-3.5.0.tar.gz"
  sha256 "9ea64b411f8314414f440ec765dfdf5a86c9f6159df47e2f60cff3db6b31157a"
  license "MIT"
  compatibility_version 1
  head "https://github.com/GothenburgBitFactory/taskwarrior.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "9d0de9d2e6ecb3f7ecfbceb621054965298cdda682c0d5e85b4ba9a51c858a18"
    sha256 arm64_sequoia: "ba9a2cf5c79e8f2828bccaee6eab9242418aee107c67b8e45133f1353cd902ed"
    sha256 arm64_sonoma:  "b2e6749d6b62ce6d43d7e4dc1a6301fc44ccfc7eda19e0a096cce4f1ac829f3a"
    sha256 sonoma:        "398a39a02ddf29d9aed6761867e62dd5d6c4b05ce5d81c4479b4850dd85dc846"
    sha256 arm64_linux:   "aa013a48142f78958970b41aa6ceeaa6583dbf34295deef22eda7f38d388dc9b"
    sha256 x86_64_linux:  "1a51f6c343c8cbe300b168c2748e1adf18f6705d423f73040abbfc2de5308e71"
  end

  depends_on "cmake" => :build
  depends_on "corrosion" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "readline"
    depends_on "util-linux"
  end

  conflicts_with "go-task", because: "both install `task` binaries"

  def install
    system "cmake", "-S", ".", "-B", "build", "-DSYSTEM_CORROSION=ON", *std_cmake_args
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
