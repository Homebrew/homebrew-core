class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://vinhnx.github.io"
  url "https://static.crates.io/crates/vtcode/vtcode-0.138.0.crate"
  sha256 "108042aa15437c822d175e4c70134e393567d813e0f99f66951eb6e570cd7352"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8e1eee39f065f903e1eb30d6ec7ff72669fdc46879159fd70e7bc233ce9cc628"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "42c0dce4a589ad527ca05319a0c888da8fcea5d2c057fcd482d869c5a3a5985d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "62dec37979dee33694bd8b8c205c9cec13eafc9cb9a65fb424cee653b770f52d"
    sha256 cellar: :any_skip_relocation, sonoma:        "944ba9cb5627780c538241e0ec9ec308c9bd3dc930981cead258445279373f92"
    sha256 cellar: :any,                 arm64_linux:   "16dccb7b8d3030488566acd88151b35a26e7bad3ac7a98348195a0c7cb54664e"
    sha256 cellar: :any,                 x86_64_linux:  "b2793511584f73bb34ec1d36bb21c3aca62be0e4a24c6e82d4dc73666682b6b7"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "ripgrep"

  on_linux do
    depends_on "openssl@4" => :build
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
