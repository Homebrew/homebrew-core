class Sk < Formula
  desc "Fuzzy Finder in rust!"
  homepage "https://github.com/skim-rs/skim"
  url "https://github.com/skim-rs/skim/archive/refs/tags/v5.0.0.tar.gz"
  sha256 "ee6fad9bd4a9188aec8dbde2461a320603cec65da941b971dd7162632e2f5d9a"
  license "MIT"
  head "https://github.com/skim-rs/skim.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "41610e198442fc9674a04a5ceaa463bb1fb6b772ff9dd2d2083e28f36a0b2a6f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c229e28e906cee25a67406ae8bf00679cefdba8591e3a859e0e5c25c2908d624"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "603a3cad3fdf35abb999f61e0540d7c156cdfa8cb406c4cf98062f8b536e0541"
    sha256 cellar: :any_skip_relocation, sonoma:        "4b246117fd7d9696defc04026f3f8e4bb8aeac0d6d11550235b5c7622895215d"
    sha256 cellar: :any,                 arm64_linux:   "31e5df38f9f9c90a048591ffb5f6076782fd321a94741c441f517e6245a65f01"
    sha256 cellar: :any,                 x86_64_linux:  "4e9ecc63081deb13dac5df20d10da641ed6d26534bc3dc0505c6aed2267cde56"
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
