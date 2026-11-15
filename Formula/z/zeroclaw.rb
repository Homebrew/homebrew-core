class Zeroclaw < Formula
  desc "Rust-first autonomous agent runtime"
  homepage "https://www.zeroclawlabs.ai/"
  url "https://github.com/zeroclaw-labs/zeroclaw/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "b39010ba7bf95b69dc483cc9e083adfa08affc6bb2dacc9792b834b52ec63c44"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/zeroclaw-labs/zeroclaw.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a9e2bc2c3124b667712645992c001453386d4a2b5d90deb41ed0cf0493cac361"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2c3ac45a441372ce7529f614cb25f1bf1e13ec54b6f37a16e4c9d27b99c97d12"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "45762192064ea1a504be8db829bab51d224c8b497b74f5d8148ce747166fc7c1"
    sha256 cellar: :any,                 arm64_linux:       "cfd2546c2cc26465aa7bdd96d7702a3bd396177103cffcc0283aba6c0313049a"
    sha256 cellar: :any,                 x86_64_linux:      "bdd6f41ff8e5d4c1dfa7708771fbe7b81f78c5ae49d26fbe4f1b16e084457ec5"
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
