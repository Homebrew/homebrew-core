class Zeroclaw < Formula
  desc "Rust-first autonomous agent runtime"
  homepage "https://github.com/zeroclaw-labs/zeroclaw"
  url "https://github.com/zeroclaw-labs/zeroclaw/archive/refs/tags/v0.5.6.tar.gz"
  sha256 "8c968abb87fbcc99b57855cb66023d29623d7348190cde0b04772c27e80b949f"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/zeroclaw-labs/zeroclaw.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b06131915c9960dfd5190a6af32ce81b0a64c60b743e7ad2da3cf2336734dfbd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "74fe8b1f00c807c427f34b9314aea895faf091afc42a05da84d19185ea0d6a44"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "08ac06025dc4463905296fa05d53f302b8d2b731a77c53782a2f76df5ebbc630"
    sha256 cellar: :any_skip_relocation, sonoma:        "0045766548cbef86ac1e661f8e02a8fbd504a79c8f8f14e8d62392887a31cc6c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "02281d57595fe8d11a1022daa3efb5a00c22ec66939cb6cb9c43deec547d82f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cb221309ee453b9868776f08088fc0a07e241e1e4a2cadcc6148a00c65bec00f"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  service do
    run [opt_bin/"zeroclaw", "daemon"]
    keep_alive true
    working_dir var/"zeroclaw"
    environment_variables ZEROCLAW_WORKSPACE: var/"zeroclaw"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zeroclaw --version")

    ENV["ZEROCLAW_WORKSPACE"] = testpath.to_s
    assert_match "ZeroClaw Status", shell_output("#{bin}/zeroclaw status")
    assert_path_exists testpath/"config.toml"
  end
end
