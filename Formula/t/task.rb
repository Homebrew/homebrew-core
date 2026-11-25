class Task < Formula
  desc "Feature-rich console based todo list manager"
  homepage "https://taskwarrior.org/"
  url "https://github.com/GothenburgBitFactory/taskwarrior/releases/download/v3.6.0/task-3.6.0.tar.gz"
  sha256 "2873ca80feb03ac202816d69a57f06403bf1c2d7ca082ac9f3aa06ad9f1d7a8a"
  license "MIT"
  compatibility_version 1
  head "https://github.com/GothenburgBitFactory/taskwarrior.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    manifest_sha256 "4cf4bc4fe04f37362260c79feb77d96bbffea86388a44d1c8c0a49cb5e067196"
    sha256 arm64_golden_gate: "f4468b0306e1c9d46b866f2e17d7aa52c1a23862052a7bce8ff8f7e734cec4c4"
    sha256 arm64_tahoe:       "a421f78fdbc6aa60fd93478e05d43d611b58fcfc5a21b701bb3867a91ef3ef7a"
    sha256 arm64_sequoia:     "088c6c5d85755ff6356726ba2400b72e20c0bc27dd8d46ff20f082397dff2010"
    sha256 arm64_linux:       "4c5c98cb80620e466dc2190ed9ca10d0131546976b190adc6822c7748fcc5d23"
    sha256 x86_64_linux:      "6121a4b57df4034801e45b6bcc2ccfcf8a987e8f143054fa0b2008ed0c9b585a"
  end

  depends_on "cmake" => :build
  depends_on "corrosion" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "readline"
    depends_on "util-linux"
  end

  conflicts_with "go-task", because: "both install `task` binaries"

  # Needed for CMake's `corrosion_add_cxxbridge`
  allow_network_access! :build

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
