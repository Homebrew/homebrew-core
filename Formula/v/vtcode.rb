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
    manifest_sha256 "eb844a57e73af75c5b6190f9d821a1e8859f63320156391cc97078813a97ff31"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "bc9404bbd13abcbe57b68f87be82265c98a69f829088239fc13c743856fef356"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f2a08af88155466f8a8e7397056760163781683e21510c7a9001636a073fa968"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c44e7d4a885a6542f729b69b36ed22c9e03ca5e83ace53c32984a5398a0f565b"
    sha256 cellar: :any,                 arm64_linux:       "c420f853c51d519576c49c2dd8616c0fa93b0e6760fedcf94e8173b0851fb0ce"
    sha256 cellar: :any,                 x86_64_linux:      "31548d5aeb943a9e2d20cb3f3328a38fb21705c4628071f2b6681473c54e435a"
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
    ENV["OPENSSL_DIR"] = dep("openssl").opt_prefix if OS.linux?
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vtcode --version")

    ENV["OPENAI_API_KEY"] = "test"
    output = shell_output("#{bin}/vtcode models list --provider openai")
    assert_match "OPENAI", output
  end
end
