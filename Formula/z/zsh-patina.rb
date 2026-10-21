class ZshPatina < Formula
  desc "Blazingly fast Zsh syntax highlighter"
  homepage "https://github.com/michel-kraemer/zsh-patina"
  url "https://github.com/michel-kraemer/zsh-patina/archive/refs/tags/1.11.0.tar.gz"
  sha256 "08577fdb5bc2dcc4ee5ebec6c0511afb6ff0f5f9b3a18bdfa94ae2d35765e56d"
  license "MIT"
  head "https://github.com/michel-kraemer/zsh-patina.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "861f2afced77ffb59aa10625e7c4a590ef74a835fb1bcf537b98d31a714a546b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "078ffebc9bb91ab83c5a258d60e9531932482be45e6903537d4971225b63e56f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "59d6f3bb18a539220787f4fe7bfee079e2c28713e3247cb03208556509ddb595"
    sha256 cellar: :any,                 arm64_linux:       "711776d6c4d48109a0546163a50a69d487219ee32baa8511e2958065871a84f2"
    sha256 cellar: :any,                 x86_64_linux:      "eab7aaa48130ece2954d860c36aedf336aa5198428c41314a3fe5a391fac8881"
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
