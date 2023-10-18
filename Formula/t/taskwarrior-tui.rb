class TaskwarriorTui < Formula
  desc "Terminal user interface for taskwarrior"
  homepage "https://github.com/kdheepak/taskwarrior-tui"
  url "https://github.com/kdheepak/taskwarrior-tui/archive/v0.25.4.tar.gz"
  sha256 "86a00c0c33f825824ac432c50e57a9bac150c3ba9e3d06e6d86f65790a99a458"
  license "MIT"
  head "https://github.com/kdheepak/taskwarrior-tui.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "32b6364e0404c43d34438200f49328df35bd3079e1b0f6723af6a895999c3f02"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "457aab331a09b05ca38e086cf6ac6f94cc3a74639def5facae37a8aae6879d9b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "016062bd3a4e1e2dd49c758c188f3b98d645133a6b94f14ae4b891c0f4784af4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c143f36d7a7837f01396e6c7e65daa9e889ca2b7afa9dbad49c2e150d095ce99"
    sha256 cellar: :any_skip_relocation, sonoma:         "1c51f93536625906cc42aab745f1785db5ea16af2906d215eba56dd3f4c8a259"
    sha256 cellar: :any_skip_relocation, ventura:        "a0db6f8e4d3c0b392b71769892e24d901b771ff4b3442fc8bccde6cc6ea44ad0"
    sha256 cellar: :any_skip_relocation, monterey:       "6563f8095c8f722f091ad25f1f15d92be1bee9435360ff6a5595d3855de1debf"
    sha256 cellar: :any_skip_relocation, big_sur:        "1fd7513cc297c3f57abea26dfb63d9a02daaebc4019fef42345f8a49d72f378e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bd1a31692755b7c9ea1047f274c3de4b403ac38041db3cd8ca3bedd83aa69dfa"
  end

  depends_on "rust" => :build
  depends_on "task"

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "docs/taskwarrior-tui.1"
    bash_completion.install "completions/taskwarrior-tui.bash"
    fish_completion.install "completions/taskwarrior-tui.fish"
    zsh_completion.install "completions/_taskwarrior-tui"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/taskwarrior-tui --version")
    assert_match "a value is required for '--report <STRING>' but none was supplied",
      shell_output("#{bin}/taskwarrior-tui --report 2>&1", 2)
  end
end
