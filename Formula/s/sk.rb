class Sk < Formula
  desc "Fuzzy Finder in rust!"
  homepage "https://github.com/skim-rs/skim"
  url "https://github.com/skim-rs/skim/archive/refs/tags/v5.5.0.tar.gz"
  sha256 "db609ae737127ada94c6147d9b3805a0ab7dd72574075773039c0908e1fd9ab6"
  license "MIT"
  head "https://github.com/skim-rs/skim.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "676695105711f8725b5f609d7d692d15a971c180aac73edac68e11ee901f1746"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1b0191f5db7067b07988b2070b91675c77a259c16298b265dc2410223e3956fa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cf881a78512606152b7fee5a28c96dee34595bd05bc11aac46afc232e725d7b2"
    sha256 cellar: :any_skip_relocation, sonoma:        "976ed3bf0a4797c7d97b1ceead55dbb30990e0a3e7b9e021e00e28c7833f1905"
    sha256 cellar: :any,                 arm64_linux:   "f4d74c5e60f66dafbdd1dd40a3d410ea7be3ea04e602fe9c0311fff4361e5729"
    sha256 cellar: :any,                 x86_64_linux:  "ad221c4ab6218608214bd95d087058e8861c6bfffee4227a44a3ce10af667799"
  end

  depends_on "rust" => :build

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
