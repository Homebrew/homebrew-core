class TaskwarriorTui < Formula
  desc "Terminal user interface for taskwarrior"
  homepage "https://github.com/kdheepak/taskwarrior-tui"
  url "https://github.com/kdheepak/taskwarrior-tui/archive/v0.23.7.tar.gz"
  sha256 "9e7dbd61219a0a7cc1916c71d05b778e515fb4eff5a22c523e4efb3ff826f4cb"
  license "MIT"
  head "https://github.com/kdheepak/taskwarrior-tui.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c416c9c6201049b80f411f7f6b143f542dba8dde54de85c5ffb2018d00c75018"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "89bf38e88de0c780d6873491e8afeeee5feeda98e2969cadcb99250366a025a3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a73ea2973856841668d174fe9c18c8e6777dad88214aa22e83ab4e99d586fa38"
    sha256 cellar: :any_skip_relocation, ventura:        "1475a1bac6f0348ed3bc593c430772dc9a11d06c42e6314752cc430ca8d88e85"
    sha256 cellar: :any_skip_relocation, monterey:       "51b679a007d65b65f3e9b2ba043e8beaa2495687ffe012dcd940194cb4659ef2"
    sha256 cellar: :any_skip_relocation, big_sur:        "9d2d095fe938c2bba73672f0b2fab1d5286befb1b599d91f4cee8f21abd41e82"
    sha256 cellar: :any_skip_relocation, catalina:       "9a8ca0f16f4588fd38c99eae06486d7d6e852946a54fc3d3b6e2e27fee1f080e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6a799e922f16f4fbde9d3bd941c7f39ff41c37a582b01bccd80231ffcba4d4b4"
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
    assert_match "The argument '--report <STRING>' requires a value but none was supplied",
      shell_output("#{bin}/taskwarrior-tui --report 2>&1", 2)
  end
end
