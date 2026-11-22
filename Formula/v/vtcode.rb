class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://vinhnx.github.io"
  url "https://static.crates.io/crates/vtcode/vtcode-0.185.0.crate"
  sha256 "615703b5e7b8064f686703481382b2ac7484754d76310db075f97ca48b4b0e06"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  livecheck do
    throttle days: 1
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "08d04baab1bbef20d890c9446d87068a66076f5ef0f3c94d6f6282cf525a0afd"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6e2f3317a2f65da4edc78c7e3c608681f0f51377e7f6a720b2c92a648f7575e8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "819e93c55dbf289dfd0e5a8d878a41858f589faa84fd3f501f7dd7db6c95b6d3"
    sha256 cellar: :any,                 arm64_linux:       "ae9ba5c66c5ca252f29a99555020d43bd8b9fcafb19afe980aab11582208e592"
    sha256 cellar: :any,                 x86_64_linux:      "8607ca3812217b088add97464ecb170cee164b423b97c6dccf9e094febc78342"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "ripgrep"

  on_linux do
    depends_on "openssl@4" => :build
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@4") if OS.linux?
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vtcode --version")

    ENV["OPENAI_API_KEY"] = "test"
    output = shell_output("#{bin}/vtcode models list --provider openai")
    assert_match "OPENAI", output
  end
end
