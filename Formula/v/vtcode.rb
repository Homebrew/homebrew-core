class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://vinhnx.github.io"
  url "https://static.crates.io/crates/vtcode/vtcode-0.182.4.crate"
  sha256 "37e45acb4b3784e6e9ddc99d9d91cd853b54c4b48bf60bcc292d54d0bf4e1883"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  livecheck do
    throttle days: 1
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0dcbb93ce92a0297cc97c51c59cd5b6284c937d69be4709765e874df8a24b675"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f2c0b022a2bac92acfe9747eabb45f62e69c5d80c83a0a3b8bf4ff82eedfa654"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "582bd9aafe27cd869854e56fbf06283dd936c8715e9f1683869ffad4eaf664e7"
    sha256 cellar: :any,                 arm64_linux:       "f0bad32c51979542398f59f6a448bf526796f1280bb3374089d758cb2208ce30"
    sha256 cellar: :any,                 x86_64_linux:      "4a7d0947b68c2a1bc00d79862c2d9ae5982efcafa4630f72e65f6dbc9d5b8949"
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
