class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://vinhnx.github.io"
  url "https://static.crates.io/crates/vtcode/vtcode-0.180.0.crate"
  sha256 "6f397980e003bc417fcb180c9477540b094e464e0c33245d2fd341045552bafa"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "99fc40db4d53c421894c0af1e34e1f67054d46805eccd72b13534955f5f3616a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "def8b9edec757b2551f7891f97693ae6d66e1ff0b746ded47bfb9462f3d27e20"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "81f7de93d494729916e3ea06da17f9bb9944e0cb3e140633d81f43bc8c09ba37"
    sha256 cellar: :any,                 arm64_linux:       "2b9309bdad7f7edd24ad8025b0f74e6d81b7a9c0f675f727314e0621ca2fb451"
    sha256 cellar: :any,                 x86_64_linux:      "e5166cf0bb6f1592b8a3d7d8e182e58c8e86f3da0910a40186653184e16bccc8"
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
