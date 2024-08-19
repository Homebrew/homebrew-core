class TodoTxt < Formula
  desc "Minimal, todo.txt-focused editor"
  homepage "http://todotxt.org/"
  url "https://github.com/todotxt/todo.txt-cli/releases/download/v2.12.0/todo.txt_cli-2.12.0.tar.gz"
  sha256 "e6da9b2c8022658c514a0b1613b3eae52f6240bf2b3494a83dae713ea445d13e"
  license "GPL-3.0-only"
  head "https://github.com/todotxt/todo.txt-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "dcd2c4f80cb1986b35d47b38e0e526e403a1a5c1c930dc652d2f3b50602e0338"
  end

  def install
    bin.install "todo.sh"
    prefix.install "todo.cfg" # Default config file
    bash_completion.install "todo_completion"
  end

  def caveats
    <<~EOS
      To configure, copy the default config to your HOME and edit it:
        cp #{prefix}/todo.cfg ~/.todo.cfg
    EOS
  end

  test do
    cp prefix/"todo.cfg", testpath/".todo.cfg"
    inreplace testpath/".todo.cfg", "export TODO_DIR=$(dirname \"$0\")", "export TODO_DIR=#{testpath}"
    system bin/"todo.sh", "add", "Hello World!"
    system bin/"todo.sh", "list"
  end
end
