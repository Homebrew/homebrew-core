class Sk < Formula
  desc "Fuzzy Finder in rust!"
  homepage "https://github.com/lotabout/skim"
  url "https://github.com/lotabout/skim/archive/refs/tags/v0.15.7.tar.gz"
  sha256 "f7c405502e352a95f267a3c73e2a2897aeec20f6e4e146328780d2bdc085ec4d"
  license "MIT"
  head "https://github.com/lotabout/skim.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f9d0c1eceb12ec0b5e382137d4394b5d46817df28c895cdd7af297991cf1142d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "52b1d9fc0d68bcc0ea18b9632a00463d525cf06f96ef916acb2841f946bcca92"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "28120ea25f26d4651178fca9386e992e4e9272fedd2954cf3b3ce962b46acf51"
    sha256 cellar: :any_skip_relocation, sonoma:        "f2faff401d27755f6d58b5ab350a5aff477428708e86a8bfe83910dd7567fd17"
    sha256 cellar: :any_skip_relocation, ventura:       "892f79462c513c7ea4c3f4cfd2b38cef14facb8db5d3c1e3c7a9f21dbfbb2bc7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2b86c64fceea748a78b94c95e13c7f0bfac26e169334cd0f9af795ca14ac3e92"
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
