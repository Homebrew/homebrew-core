class Sk < Formula
  desc "Fuzzy Finder in rust!"
  homepage "https://github.com/lotabout/skim"
  url "https://github.com/lotabout/skim/archive/refs/tags/v0.16.0.tar.gz"
  sha256 "dd596fdb57fc8f7e94ad240839d93b14b775d3be38e74293922c2e048ef13f15"
  license "MIT"
  head "https://github.com/lotabout/skim.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0be328faef845b2b3490ce105de3b026f9265d8d8e72ce573bf4979ba028f2f2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d6ea1dd5e88db4f4cb36b5cf644358e011df94855d832f9ec5bc4bc1d61b30fa"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "126b17461e79ab9bdbee50636819e514029a283a5e3bfc14ee7a3eb8fc26eb29"
    sha256 cellar: :any_skip_relocation, sonoma:        "b022bf9f9366756910a9d54daf458e2818b153c65eb202fab8aa7e1d1f0a2bcd"
    sha256 cellar: :any_skip_relocation, ventura:       "b0cbaf308d3d484511a538d8a45b330f250247c1beb47ab3e5999c046764cf27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c5d3ba32079a800d01bf8507e2c168ee59df66b20039a2892fb6ae6dd9cc35fe"
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
