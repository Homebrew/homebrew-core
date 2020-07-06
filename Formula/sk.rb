class Sk < Formula
  desc "Fuzzy Finder in rust!"
  homepage "https://github.com/lotabout/skim"
  url "https://github.com/lotabout/skim/archive/v0.8.2.tar.gz"
  sha256 "04af8e9facd8a9f10e9d18f02b78e6d80e987cd58937df960c9b48ae5f42b761"
  license "MIT"
  head "https://github.com/lotabout/skim.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5292b952619fdff305f8124e8ff7342487c2b8904582d21d7d36ee70552e55cb" => :catalina
    sha256 "88cd830c34f998238c0bc89e435fa114fd89081bada5e6c04baed79d5f97f2c9" => :mojave
    sha256 "cdf01b18bb6d20bbe3063246520e09caf0591490212e1ced07e996027a87dc32" => :high_sierra
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
