class TodoTxt < Formula
  desc "Minimal, todo.txt-focused editor"
  homepage "http://todotxt.org/"
  url "https://github.com/todotxt/todo.txt-cli/releases/download/v2.14.0/todo.txt_cli-2.14.0.tar.gz"
  sha256 "71a703ecbf79a163f1aa9b831e7ea0e6036cdbb06fdfc6b5c3502b627efb873d"
  license "GPL-3.0-only"
  head "https://github.com/todotxt/todo.txt-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e1c6671d40bdcdfb08ba1ed0cd23d6cc758dc61b087dd6b546e399aa3417b74e"
  end

  def install
    bin.install "todo.sh"
    prefix.install "todo.cfg" # Default config file
    bash_completion.install "todo_completion"
  end

  def caveats
    <<~EOS
      To configure, copy the default config to your HOME and edit it:
        cp -n "#{opt_prefix}/todo.cfg" ~/.todo.cfg
    EOS
  end

  test do
    cp prefix/"todo.cfg", testpath/".todo.cfg"
    inreplace testpath/".todo.cfg", ': ${TODO_DIR:="${HOME:-$USERPROFILE}"}', ": ${TODO_DIR:=\"#{testpath}\"}"
    system bin/"todo.sh", "add", "Hello World!"
    system bin/"todo.sh", "list"
  end
end
