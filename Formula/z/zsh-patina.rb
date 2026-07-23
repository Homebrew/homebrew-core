class ZshPatina < Formula
  desc "Blazingly fast Zsh syntax highlighter"
  homepage "https://github.com/michel-kraemer/zsh-patina"
  url "https://github.com/michel-kraemer/zsh-patina/archive/refs/tags/1.9.0.tar.gz"
  sha256 "a16736d510d3019edaabad3e54eaa39d2583fc15cb30463eb1dc9f3cb6b2fe77"
  license "MIT"
  head "https://github.com/michel-kraemer/zsh-patina.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6b89ff5698197c90670e4f2738900e99c46fd8484e1044dbae04d44b92ba0ad4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3f2e9db3e8be1bcb7f5cb079a80ac2b63d9e146de17c4728c5c681db8b108ef5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b53c10d27e8fecb9e987f1d4b759c69263b938826083dab8b72a5ff69c5133e4"
    sha256 cellar: :any_skip_relocation, sonoma:        "612e6e510fbd0b0292b404aa3bafacc661246a99dd251d92931287ede4d67035"
    sha256 cellar: :any,                 arm64_linux:   "2ea504ba00eae76cadbedda73bdb63305444000a7339a2f6c42a99263983eab5"
    sha256 cellar: :any,                 x86_64_linux:  "f7b35686460b1d11ed35fa8f2b4fa24b80de853d5005ceca5071f4afeccea836"
  end

  depends_on "rust" => :build

  uses_from_macos "zsh" => :test

  def install
    ENV["CARGO_PROFILE_RELEASE_LTO"] = "fat"
    ENV["CARGO_PROFILE_RELEASE_CODEGEN_UNITS"] = "1"

    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"zsh-patina", "completion",
      shell_parameter_format: :none, shells: [:zsh])
  end

  def caveats
    <<~EOS
      Initialize zsh-patina at the end of your `.zshrc` file by executing:
        echo 'eval "$(#{opt_bin}/zsh-patina activate)"' >> ~/.zshrc
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zsh-patina --version")

    output = shell_output("zsh -c 'eval \"$(#{bin}/zsh-patina activate)\" && type -w zsh-patina'")
    assert_match "zsh-patina: function", output
  end
end
