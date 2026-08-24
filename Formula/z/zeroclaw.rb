class Zeroclaw < Formula
  desc "Rust-first autonomous agent runtime"
  homepage "https://www.zeroclawlabs.ai/"
  url "https://github.com/zeroclaw-labs/zeroclaw/archive/refs/tags/v0.8.4.tar.gz"
  sha256 "683273de5e4765cdd77fe81bf68212c2eb9b1b2603cbfafb79d9a4f2c9dcd706"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/zeroclaw-labs/zeroclaw.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "412d6e27deda3ba76596a8a05f7a91af2e3fa59053cf9179303e0c4218b051d7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "43486a6c169dfa4e272f5d0920134531e129b124fcdf7def91ff6293c576d12c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7c857b9448d7b9771276416061d8fdd6a92ec685c106f02a8a71a07a1f6fee72"
    sha256 cellar: :any_skip_relocation, sonoma:        "b0aa8db3372eb7b3b153de35f1606c4e70ef0a3eb0c8a9f876953b028b650a53"
    sha256 cellar: :any,                 arm64_linux:   "7d3f4f2dee0e67b555fb06b6e8f8bd2b4b1e6d2b74d91fb732e1271c607d736e"
    sha256 cellar: :any,                 x86_64_linux:  "58d53fd4f10d80d4c5cfc0ef1d6746353f2772e1a77b2a29e96879330bb452ed"
  end

  depends_on "rust" => :build

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
