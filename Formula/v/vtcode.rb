class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://vinhnx.github.io"
  url "https://static.crates.io/crates/vtcode/vtcode-0.185.1.crate"
  sha256 "add529c4e9f98c7e07e6baf40ed64a9816535f368bdfb8e0fd2a1b938e8c0459"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  livecheck do
    throttle days: 1
  end

  bottle do
    manifest_sha256 "15d9533246f504b13d84635abf212381be2a93a5e11eb8aa6c524551eb389d2c"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f860ceb3a4cb6410b978ff5753e796181168542b013e18a9f6a3de57421bd02a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b4810a1955fe9e0ba6fa15030adf567a4e7b861edb8b087510311041ad06821d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d62b76524b40057fdf9645cdbdf9577631506f03466ac3d5ce41e2d09cc24274"
    sha256 cellar: :any,                 arm64_linux:       "922f392651340ef0993d9b508407810b9ae54e2e29493e77df3d844fa80d29e5"
    sha256 cellar: :any,                 x86_64_linux:      "596bf5176e86b8fef9e5931ed7dfb040ebf3d5c27f870c07f91c5d8f39b4279c"
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
