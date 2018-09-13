class Task < Formula
  desc "Feature-rich console based todo list manager"
  homepage "https://taskwarrior.org/"
  url "https://taskwarrior.org/download/task-2.5.1.tar.gz"
  sha256 "d87bcee58106eb8a79b850e9abc153d98b79e00d50eade0d63917154984f2a15"
  head "https://github.com/GothenburgBitFactory/taskwarrior.git", :branch => "2.6.0", :shallow => false

  bottle do
    sha256 "bba98b6bdfb3f79f1434229d8ade4b0622119320353da0eb8fec39809d66947d" => :mojave
    sha256 "6a651be957b736bef14633efedef011a81c49ee37178eae4d8ef863549d7c584" => :high_sierra
    sha256 "d1cb582ab9ee211ec154690634b5988f8058ead31000c74d5cdfa949d319d0ed" => :sierra
    sha256 "07aa2c19ae6d7a9a46b286bfc48fa970aa9a9e0237e034bbaab354dcfc4f6848" => :el_capitan
    sha256 "113fc7ce057c51ea14021006a4106c25d29e361e4b70113e33fb7a83e57ee8d1" => :yosemite
    sha256 "7888e42210edb6691ff57d056585536abd318d62b43a898bb98e286373519164" => :mavericks
  end

  depends_on "cmake" => :build
  depends_on "gnutls"

  needs :cxx11

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
