class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://github.com/vinhnx/vtcode"
  url "https://static.crates.io/crates/vtcode/vtcode-0.58.9.crate"
  sha256 "d06b1474a3ef6bde43fd39f92f1602fa70b35de2a53d271985f129bc1a7fad4e"
  license "MIT"
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d9e6720a608eef509775ce3599680f91619059445855ba8a11b6a7f073066f66"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "98f18d0435f359f881c69741ca59c1e70153927daa3547c58442999fb9de3513"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "87665ffa7411d1ca72019729d1a7100560d19e6a2b3ca23c0c4fba048bb47b08"
    sha256 cellar: :any_skip_relocation, sonoma:        "7ab7072621bd7291fddd2a847d3361aad3b8c1f2df0a8bfef63b8bd7ad9c82ee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b4fe8045ee5b97f918f3e527115e565ced56086efb5db0b5c461454649751e44"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "58e97137b3de2e43fb905a2ca16d827343f47d1d2405906c9ce48ecd122d1c84"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "zlib"

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vtcode --version")

    output = shell_output("#{bin}/vtcode init 2>&1", 1)
    assert_match "No API key found for OpenAI provider", output
  end
end
