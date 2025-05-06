class Sk < Formula
  desc "Fuzzy Finder in rust!"
  homepage "https://github.com/lotabout/skim"
  url "https://github.com/lotabout/skim/archive/refs/tags/v0.17.2.tar.gz"
  sha256 "afdef2f53dcc0f51cc5a4b28c3a21b02cf82436970535a01d3fffaa6499b23a2"
  license "MIT"
  head "https://github.com/lotabout/skim.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e3e1617c509f40f3555699dd883c286ee6ffc3e2dbec510df003416f9bb39a56"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5e449f611bb43553b080e5418765318f5606e22170b23a8d9ba7834d0e46f432"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "571967a7e1e2e782d6cb659ac71bdb2fce766ed105b5c730f3cc9a0ed98f8ce4"
    sha256 cellar: :any_skip_relocation, sonoma:        "de06dc1cc1f0cfd55b6ebe9010cb57ca6ce3098e22db527bf9ce3454ca6de838"
    sha256 cellar: :any_skip_relocation, ventura:       "e1d6fa718d27894a32f0aa9fe72deb8d276656bfdc3c39ad4f30d5b3c9c9dc54"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8ed3cbd1fe21d64ba203aa40c48c461bed4b6a6571105aaa20fe2a68a0c7544a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "25972a1c9da970967b3a8f30aae24bd584ed3af8a2db2f23b8ab9ee5b27af521"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "skim")

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
    assert_match(/.*world/, pipe_output("#{bin}/sk -f wld", "hello\nworld"))
  end
end
