class Sk < Formula
  desc "Fuzzy Finder in rust!"
  homepage "https://github.com/lotabout/skim"
  url "https://github.com/lotabout/skim/archive/refs/tags/v0.18.0.tar.gz"
  sha256 "028cabc0df171c34343fae340132a2b718aae4f405320b11c47f22173ca43b57"
  license "MIT"
  head "https://github.com/lotabout/skim.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6868f9fe96ec5c0d7b8902d899c18890891e7544ac1bc28162eaf87b50f99093"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9431659a7982069217f83e05d3056ba129ea6992f1870ceff013471d6bd9fb3b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "57d6f0a86b72e1e127a3ff1554ddc95c1001ee82f67e8598b46a65eb80b32258"
    sha256 cellar: :any_skip_relocation, sonoma:        "42de4cacd02a57631206da340a0cf41c61024646249ff5b10e575548f8c52e8b"
    sha256 cellar: :any_skip_relocation, ventura:       "f6bf0f7d06c271897b7d4a40efd03a1ef9cb2ea4975fb559a08a2fa2f010c76b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d36d7c3228f09efeb00b2ffaa959ebd0d624f56bc4110acb31a6e1e34d3ff7bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "84e4800542eed80c43148e2cc06e81291c10452c831bcfbeb4c141e617034059"
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
