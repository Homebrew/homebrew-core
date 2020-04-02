class Sk < Formula
  desc "Fuzzy Finder in rust!"
  homepage "https://github.com/lotabout/skim"
  url "https://github.com/lotabout/skim/archive/v0.8.1.tar.gz"
  sha256 "66eab31697b7bb373e6e26aa62e0c76f725f36269da105197f447489f6ec477b"
  head "https://github.com/lotabout/skim.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d5327be32f3c6e14fc62bfc22429a4bdd00c341fc413ccbe638d316f7fe4600b" => :catalina
    sha256 "b1fc07b28e1a55820121ec200ecece04a885746b8bbcd3f6401b6e1acbba0f12" => :mojave
    sha256 "38aed0bf7bcb20fe579188c583100d5c6a4faef77f92fc808fb43b986dddf298" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    (buildpath/"src/github.com/lotabout").mkpath
    ln_s buildpath, buildpath/"src/github.com/lotabout/skim"
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."

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
