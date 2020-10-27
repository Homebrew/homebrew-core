class Sk < Formula
  desc "Fuzzy Finder in rust!"
  homepage "https://github.com/lotabout/skim"
  url "https://github.com/lotabout/skim/archive/v0.9.2.tar.gz"
  sha256 "0201367d671e3e31d4e3faf13dc87a7f4aaf32bbadb63b9406c500f9d8684986"
  license "MIT"
  head "https://github.com/lotabout/skim.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "eae85d55547ad47ee6e5a9e7123ffee741eddb444fd6df555ab2d29d559881cc" => :catalina
    sha256 "e2f1fd4afbaf9ab007876517266277f0124dc51d5ab1a97ffdf3843f1c3f9372" => :mojave
    sha256 "15a9ca7198bfa40597ca0533a5294c2d5484dc26004e33b26cc44dc7dcd370bd" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    (buildpath/"src/github.com/lotabout").mkpath
    ln_s buildpath, buildpath/"src/github.com/lotabout/skim"
    system "cargo", "install", *std_cargo_args

    pkgshare.install "install"
    bash_completion.install "shell/key-bindings.bash"
    bash_completion.install "shell/completion.bash"
    fish_completion.install "shell/key-bindings.fish" => "skim.fish"
    zsh_completion.install "shell/key-bindings.zsh"
    zsh_completion.install "shell/completion.zsh"
    man1.install "man/man1/sk.1", "man/man1/sk-tmux.1"
    bin.install "bin/sk-tmux"
  end

  test do
    assert_match /.*world/, pipe_output("#{bin}/sk -f wld", "hello\nworld")
  end
end
