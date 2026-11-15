class Sk < Formula
  desc "Fuzzy Finder in rust!"
  homepage "https://github.com/skim-rs/skim"
  url "https://github.com/skim-rs/skim/archive/refs/tags/v5.9.0.tar.gz"
  sha256 "ef0a254a8bdf5ffc52dd5ebf909e7ed0498976b445dfadb8c412c29c1279baed"
  license "MIT"
  head "https://github.com/skim-rs/skim.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a3c7a606d83730dbdeb9fb3472c8267cf266c9829f909dee857bf1c9bb9e5fad"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "fea644ff8744b8d2a336cd516183cf766c2004dd461c50099ed15e2e8458598e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2cc0b03af7a8cdd88bc6c97953d3370793605b1b3dc6dd7c8b9ce2662926f312"
    sha256 cellar: :any,                 arm64_linux:       "18eabeacdebbd1bc49a5b61fc056bee9199e1b04b7f354fcb2fc27662394b6aa"
    sha256 cellar: :any,                 x86_64_linux:      "b3278a94a7708751f80fd62f0b47f7a8c0162763eda80a8210d2006b6705f0d0"
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
