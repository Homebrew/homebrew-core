class Sk < Formula
  desc "Fuzzy Finder in rust!"
  homepage "https://github.com/skim-rs/skim"
  url "https://github.com/skim-rs/skim/archive/refs/tags/v5.6.6.tar.gz"
  sha256 "4f988bf6da4a5e1f71e296d7f96047db2d24253a06a5597b179206f7ecd034d7"
  license "MIT"
  head "https://github.com/skim-rs/skim.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e251502b810d05888409305772e3e1722b8d74193ffcb853d03b0f9364bcdcf9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e8e897d93420b25575b1f477e96e7ba7cf382f9f88da73257af2acb3dc82d85c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0373a6f1a0115f965644dd4e4d5107dd58b970dcb85ada0f9f4b6acc66b2af93"
    sha256 cellar: :any_skip_relocation, sonoma:        "45c22ab44b016f19f5cb940497132e1a4f4724e0d73fe0eed3fc8a0c948a9a70"
    sha256 cellar: :any,                 arm64_linux:   "02a5dd1accaa89124bf55b348c4256a4fe60fdae2bdd5395f711c55ad8f82e24"
    sha256 cellar: :any,                 x86_64_linux:  "1f0f9e5ded752bede9054c11c3934d019068990eef2c7566a9be43d62dad075d"
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
