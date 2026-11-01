class Ryl < Formula
  desc "Fast YAML linter and formatter written in Rust"
  homepage "https://ryl-docs.pages.dev"
  url "https://github.com/owenlamont/ryl/archive/refs/tags/v0.28.0.tar.gz"
  sha256 "4e652e61f38e9d563764774ac6d2e9eff0bde5641a350deaa2a94c861ad85959"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b80275580baf2b906af0ae41e3126fb56628121b25b75f3c5041608ca87a89dc"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "23acecafe3cadb3da289a0a65f23d29be05051e2b94facbd4c96a3febc6d6323"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "710d13e7d5cafeeeb0c766f0e620062aa843b0a4e3793409e1615acad0bbfc96"
    sha256 cellar: :any,                 arm64_linux:       "09cf46881e7e94523bac30ced885bcc8a39581c760b1b2adc104971c577e52b4"
    sha256 cellar: :any,                 x86_64_linux:      "157c588b13490f36bf75ec7496e37c7400d509cf7089ee59cd106ee5e5de2c4c"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"ryl", "--generate-completions")
  end

  test do
    (testpath/"valid.yaml").write <<~YAML
      %YAML 1.2
      ---
      ...
    YAML
    system bin/"ryl", "check", "--enable", "ALL", "valid.yaml"
  end
end
