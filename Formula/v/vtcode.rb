class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://github.com/vinhnx/vtcode"
  url "https://static.crates.io/crates/vtcode/vtcode-0.123.5.crate"
  sha256 "8757e070598f2aee85fb522d49f1d2f3055564ad6fc1e1feed396ac7d06a0cfc"
  license "MIT"
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fc765663b3093e6f58dc1027f97c56ab160e7cbe40acbc94d4b9fd8e673c5b44"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4c333969bd04deacf938b8c05346227465bf266c3ee330b30e2fa63054cad463"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4db2fd402c586de555486cb8adb8b6c9c6c130fc22ce0e19c41c4f319c27593a"
    sha256 cellar: :any_skip_relocation, sonoma:        "f6be4a5255ceebf4fa175f6707ec099f2b706c179b9d859f23be169709c9fc6f"
    sha256 cellar: :any,                 arm64_linux:   "abdfe7fb4619902603258fda55b18e9287d34d7e91df3a02c95e90cb68f81af0"
    sha256 cellar: :any,                 x86_64_linux:  "2767b44239f3533e179599cc186c3aad91bb89e8df18ffd90da8e4a616a30a30"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "ripgrep"

  on_linux do
    depends_on "openssl@4" => :build
  end

  def install
    ENV["OPENSSL_DIR"] = Formula["openssl@4"].opt_prefix if OS.linux?
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vtcode --version")

    ENV["OPENAI_API_KEY"] = "test"
    output = shell_output("#{bin}/vtcode models list --provider openai")
    assert_match "OPENAI", output
  end
end
