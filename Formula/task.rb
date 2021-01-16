class Task < Formula
  desc "Feature-rich console based todo list manager"
  homepage "https://taskwarrior.org/"
  url "https://github.com/GothenburgBitFactory/taskwarrior/releases/download/v2.5.3/task-2.5.3.tar.gz"
  sha256 "7243d75e0911d9e2c9119ad94a61a87f041e4053e197f7280c42410aa1ee963b"
  license "MIT"
  head "https://github.com/GothenburgBitFactory/taskwarrior.git", branch: "2.6.0", shallow: false

  livecheck do
    url "https://taskwarrior.org/download/"
    regex(/href=.*?task[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 "0a5aa472b0830025324a8f73c58215fecef5c3c1bf8f1b0990a1fd370931c4c0" => :big_sur
    sha256 "0362dd5bf421b919ff93b7be95e7b43ec7007f21fe45600578a1a05fd4e0ea08" => :arm64_big_sur
    sha256 "24c80011867aa34766864a4bbac071493fb45c93bd3e08b3e9979b3ba4780fa2" => :catalina
    sha256 "bba98b6bdfb3f79f1434229d8ade4b0622119320353da0eb8fec39809d66947d" => :mojave
    sha256 "6a651be957b736bef14633efedef011a81c49ee37178eae4d8ef863549d7c584" => :high_sierra
    sha256 "d1cb582ab9ee211ec154690634b5988f8058ead31000c74d5cdfa949d319d0ed" => :sierra
    sha256 "07aa2c19ae6d7a9a46b286bfc48fa970aa9a9e0237e034bbaab354dcfc4f6848" => :el_capitan
    sha256 "113fc7ce057c51ea14021006a4106c25d29e361e4b70113e33fb7a83e57ee8d1" => :yosemite
    sha256 "7888e42210edb6691ff57d056585536abd318d62b43a898bb98e286373519164" => :mavericks
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
