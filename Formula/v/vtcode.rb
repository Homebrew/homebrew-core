class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://vinhnx.github.io"
  url "https://static.crates.io/crates/vtcode/vtcode-0.128.0.crate"
  sha256 "528289749895379fe73a6820d3083e1b0a94b66aeb4ce0160e50c9104eac946f"
  license "MIT"
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eb078714ed8044d0a676669e37d0ad84546a0f71159372129b436be80fa1eb52"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6851adc9b444533ab289771616df145b0737a4cb17e3bf8573928e571215d099"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "46add31a86c3b942d5b20c19f97d22eb79b113bbbd08b720a18634d29a8913a9"
    sha256 cellar: :any_skip_relocation, sonoma:        "fb6b286ea7ca36588c2217699ed474448c4ab7568a035e2cb0e9cdcfe498c839"
    sha256 cellar: :any,                 arm64_linux:   "7a7ec5a4b0a35e96ad0408d6105dd3933348a2b2abe0ca1e9b9ef0f1e5c0b94b"
    sha256 cellar: :any,                 x86_64_linux:  "490e24b7a47ea8c75885b8f62663199922b39bee94c8ac2133d66f167539a38f"
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
