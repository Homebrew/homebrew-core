class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://vinhnx.github.io"
  url "https://static.crates.io/crates/vtcode/vtcode-0.162.0.crate"
  sha256 "11f5a485cad2bde9deb82e8ac39a6d846ee4ac7e9fbe8e1254362e0b9c0c574d"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8fd5d3bb3cecf5ceb073192725ff0055c702150b0c58e5100af9bcb04bdef8c6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "cf4ec00d6be0720dcef32b76087fd78a9b118e9594afeb9f2c538a9a92a56d31"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7654372a938cb6c807f4d1b0bf75d39d1f71c48d6b806ac86d242934decde2e9"
    sha256 cellar: :any,                 arm64_linux:       "ad10f965696dc7c5883d0a6b896d5329d00256f4324c157deef38df6a573f893"
    sha256 cellar: :any,                 x86_64_linux:      "11a152c81379390b63825b0abc053ebeef0af9c27d1af5fab2e05f7cd988292e"
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
