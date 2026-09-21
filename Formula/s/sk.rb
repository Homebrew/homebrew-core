class Sk < Formula
  desc "Fuzzy Finder in rust!"
  homepage "https://github.com/skim-rs/skim"
  url "https://github.com/skim-rs/skim/archive/refs/tags/v5.7.0.tar.gz"
  sha256 "3a239d8ee284206e5a3891b2fd4e9dfe9150d120a63912b4b764bec2e6ef3966"
  license "MIT"
  head "https://github.com/skim-rs/skim.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "aac75482271ee92292a32182b09ee60c02ad4d159a3bf67a00ed9a3fc9e85a0d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b1e8ed7fce5aab8569c947892522f410e61e060cc4a275accb6cdc36ba7d8bfd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "bde1951675bd6926f0de967e538861a173f47390421062c6e051d53655f2f449"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "5927ab87cf6d45e664570cd471f2206d75f7c272ab45aeeb60231c72fecc36a4"
    sha256 cellar: :any,                 arm64_linux:       "d143eacc37a1917adf9b385da4d270c4253d47a776b6fb4eb4bd870403d40bf6"
    sha256 cellar: :any,                 x86_64_linux:      "ed41fd107f83b88e12894269e8e1784d4c319da4c5ce67308192aa9bea8e7c5d"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", "--locked", "--target", "host-tuple"
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
