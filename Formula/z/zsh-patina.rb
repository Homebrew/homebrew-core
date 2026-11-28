class ZshPatina < Formula
  desc "Blazingly fast Zsh syntax highlighter"
  homepage "https://github.com/michel-kraemer/zsh-patina"
  url "https://github.com/michel-kraemer/zsh-patina/archive/refs/tags/1.12.0.tar.gz"
  sha256 "fb9e04ac4d10c0a5e136bf51d84a756367615a1864de16d272379dc07901fff6"
  license "MIT"
  head "https://github.com/michel-kraemer/zsh-patina.git", branch: "main"

  bottle do
    manifest_sha256 "04c8e9552ca72ff78a0acda11f360af2c048b54e35c49d79f246c18833b8391c"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ddd1ab6eb70ddf8c4ac55a3a847538104bb8b9e1e9ee2afc7f40d2b3b2abbec0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "510d187fdf47acb53715cb28435ecdae69effc5728a380428e8f9feeddb30b6c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "af51432cda28da136ae201bb5f9eed7bb07cce11ed7c786d1bbd56c559b8c161"
    sha256 cellar: :any,                 arm64_linux:       "77d35a8e72205726adc2a0d472dc51ecc8d1b35e78d3652b0b9a51361061476a"
    sha256 cellar: :any,                 x86_64_linux:      "fa4fe13392d2ea7bf290e7065289c0021dce6b5b06700063b957d76fa1f0de19"
  end

  depends_on "rust" => :build

  uses_from_macos "zsh" => :test

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

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
