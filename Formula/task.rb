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
    sha256                               arm64_ventura:  "2102db063dd8ff63b36a1503bec0255e1f51a7096fb0b0f923eacdf6cdddc3cf"
    sha256                               arm64_monterey: "f795845e5ec49a639baf6e7eab024f038ad1151c62ec03916752877941f5c89e"
    sha256                               arm64_big_sur:  "3eef2acca71784b22e30ed3869c92b84c42bb47728e3df7709a5352dd0c4cf9c"
    sha256                               ventura:        "6e281f77be42efe002f195670b816170a66773e9012419cea071d3f23bef24ee"
    sha256                               monterey:       "b243e5436b6c1401acf8118e6163f80853027bfbbc4263ed3ce6e71dcec707ab"
    sha256                               big_sur:        "97758b4159fbf81aa71d5ee67f845b8d6369bb6f9867593bdf862a34127ebd91"
    sha256                               catalina:       "c4a17d47447ecd06f66c518e4066ae583172aa1fe15909afa726dbf2664cf7b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2b5ed87042464d45e38a60c81fd70659f87dfbb0403bbb8a4c6df4d275581775"
  end

  depends_on "cmake" => :build
  depends_on "gnutls"

  on_linux do
    depends_on "linux-headers@5.15" => :build
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
