class Task < Formula
  desc "Feature-rich console based todo list manager"
  homepage "https://taskwarrior.org/"
  url "https://github.com/GothenburgBitFactory/taskwarrior/releases/download/v3.0.2/task-3.0.2.tar.gz"
  sha256 "633b76637b0c74e4845ffa28249f01a16ed2c84000ece58d4358e72bf88d5f10"
  license "MIT"
  head "https://github.com/GothenburgBitFactory/taskwarrior.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256                               arm64_sonoma:   "c7bb516aab20211303506c26330beafd2116950d13d495cf138ae4b7fd8c68e8"
    sha256                               arm64_ventura:  "0affb9d430ca4f4fe33ff62b9a762e8ffb91b0d3464ebd3207de18c585f24fb1"
    sha256                               arm64_monterey: "c8bff30788e8d7a03605b4282624cb0544cb7cbea0a8091d107c7365347bfb03"
    sha256                               sonoma:         "544fd8c8ec8e4c0e8a64547bcc8ecd330c1273147b2f3b4c006c4082d8ea6077"
    sha256                               ventura:        "7780622b9e8391f6be90daa5445bb35275c90a7739968b088711e8264eca7e54"
    sha256                               monterey:       "05d8e2f0ae30a4dfd54ffaf39b574240dc074b1151255cdb6def06741c1dcc19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7cc796bcfe91d1f25ef91dcf19e3ae4491f9f8eb065265c8c438e2a1afb3e9f3"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build
  depends_on "corrosion"
  depends_on "gnutls"

  on_linux do
    depends_on "linux-headers@5.15" => :build
    depends_on "readline"
    depends_on "util-linux"
  end

  conflicts_with "go-task", because: "both install `task` binaries"

  fails_with gcc: "5"

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
    system "#{bin}/task", "add", "Write", "a", "test"
    assert_match "Write a test", shell_output("#{bin}/task list")
  end
end
