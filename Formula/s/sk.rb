class Sk < Formula
  desc "Fuzzy Finder in rust!"
  homepage "https://github.com/skim-rs/skim"
  url "https://github.com/skim-rs/skim/archive/refs/tags/v5.8.0.tar.gz"
  sha256 "644c830191488bf307603bccdf1b8d5972b76484f10050d35b81ab653e19994f"
  license "MIT"
  head "https://github.com/skim-rs/skim.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "52f6c7881a5ca3215bd89ee03b900a3b04bf7f57fff915baef222f35a1e69ec4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "31d31c810d9d5082cfe3337fb7244a7c0a1c9604416acfba2c9ff2ccdd2cf017"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7e106fa6c6a798899dff7c28809cd6f5756c775163cbad7bd4ac4a4360db1ec5"
    sha256 cellar: :any,                 arm64_linux:       "aee1391c9fd287b2496b8837b6cf410be7811fcf450e6cb179a870dc48b58acd"
    sha256 cellar: :any,                 x86_64_linux:      "a4f8f39a5b4f58764c161f21dee282e7cbd6ae8ab4a710469800ec11285427a8"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"sk", "--shell")
    bash_completion.install "shell/key-bindings.bash"
    fish_completion.install "shell/key-bindings.fish" => "skim.fish"
    zsh_completion.install "shell/key-bindings.zsh"
    man1.install buildpath.glob("man/man1/*.1")
    bin.install "bin/sk-tmux"
  end

  test do
    assert_match(/.*world/, pipe_output("#{bin}/sk -f wld", "hello\nworld"))
  end
end
