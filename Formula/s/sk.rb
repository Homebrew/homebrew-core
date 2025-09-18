class Sk < Formula
  desc "Fuzzy Finder in rust!"
  homepage "https://github.com/skim-rs/skim"
  url "https://github.com/skim-rs/skim/archive/refs/tags/v0.20.5.tar.gz"
  sha256 "c9b367bd37daa38b95a5da1e8f967279f4127168a38986b2f7d33a4b5fd413c2"
  license "MIT"
  head "https://github.com/skim-rs/skim.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8673c1f23e20a9046e5341e7f9bb2029966aad393adea9a92c839332e99a3807"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0e64e2ab2050344a8e178d635f300acb272a27b414efcce6dc06296b6414c84c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ef46fab492395a38197dd582bb66e594b968ad7368598f96ba72568ed08b36f0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d93770fb5e79c73492e01038943ea22e440987d309aefe40f0b0379c68266843"
    sha256 cellar: :any_skip_relocation, sonoma:        "385dc10fb64e302ccbb054ae5fed0d15dbebe8f203ac215fb865978d43d2d1f7"
    sha256 cellar: :any_skip_relocation, ventura:       "d0eec0b3b53c89451193f3e81d44a70a2a1cd1a5895afd7c2e7523c0a5a74ca0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c2faf26cdaba0186091d6454bfb9904e5acb4a54c1c084fa3b9ba5293eb615aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2631947f06f94f9f1f0bce68d0684da6770f379ebe15d6a323b0fbcda8a492d2"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "skim")

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
