class Sk < Formula
  desc "Fuzzy Finder in rust!"
  homepage "https://github.com/lotabout/skim"
  url "https://github.com/lotabout/skim/archive/v0.6.6.tar.gz"
  sha256 "5975b21a7c3792e910ee9439b41b417e92f2fc7bc92d033e2d4c6d6c48a469c8"
  head "https://github.com/lotabout/skim.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2181bedc3675e45f36e0e81d0af742cb0a298358d16d308032a583f4a0471991" => :mojave
    sha256 "225b8c28c12cf38ae37086707019e9828eb18472f39a28e0e93c984d6d8dcd82" => :high_sierra
    sha256 "757c865a849246a6a75776071053ef629698505adca904e432a0bc634c978e98" => :sierra
  end

  depends_on "rust" => :build

  def install
    (buildpath/"src/github.com/lotabout").mkpath
    ln_s buildpath, buildpath/"src/github.com/lotabout/skim"
    system "cargo", "install", "--root", prefix, "--path", "."

    pkgshare.install "install"
    bash_completion.install "shell/key-bindings.bash"
    bash_completion.install "shell/completion.bash"
    zsh_completion.install "shell/key-bindings.zsh"
    zsh_completion.install "shell/completion.zsh"
    man1.install "man/man1/sk.1", "man/man1/sk-tmux.1"
    bin.install "bin/sk-tmux"
  end

  test do
    assert_match /.*world/, pipe_output("#{bin}/sk -f wld", "hello\nworld")
  end
end
