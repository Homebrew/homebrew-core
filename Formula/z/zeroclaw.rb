class Zeroclaw < Formula
  desc "Rust-first autonomous agent runtime"
  homepage "https://www.zeroclawlabs.ai/"
  url "https://github.com/zeroclaw-labs/zeroclaw/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "b39010ba7bf95b69dc483cc9e083adfa08affc6bb2dacc9792b834b52ec63c44"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/zeroclaw-labs/zeroclaw.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "999bb31d3f49eb1a3f5ba8853023694c285e8bc1a1afe30d61a9036f7969baa5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "090053167d12a9f3c198f9066c4a760203c73a471edd8b94e64326258be3f300"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5cd18864cde1f401e28f19812db13cfb67f76e98feebdd02b4af37323761f69f"
    sha256 cellar: :any,                 arm64_linux:       "8d2e8ad8eb4ac1cc5df35df166a8e8c79dc5060b39a52b0bfb31db1c9bec94f1"
    sha256 cellar: :any,                 x86_64_linux:      "7da71b843d33b9f8480604cf4943b13121c188aabe1e12d676f7872011ce159a"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
    system "cargo", "install", *std_cargo_args(path: "apps/zerocode")
  end

  service do
    run [opt_bin/"zeroclaw", "daemon"]
    keep_alive true
    working_dir var/"zeroclaw"
    environment_variables ZEROCLAW_WORKSPACE: var/"zeroclaw"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zeroclaw --version")
    assert_match version.to_s, shell_output("#{bin}/zerocode --version")

    ENV["ZEROCLAW_WORKSPACE"] = testpath.to_s
    assert_match "ZeroClaw Status", shell_output("#{bin}/zeroclaw status")
    assert_path_exists testpath/"config.toml"
  end
end
