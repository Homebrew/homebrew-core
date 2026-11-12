class Scw < Formula
  desc "Command-line Interface for Scaleway"
  homepage "https://www.scaleway.com/en/cli/"
  url "https://github.com/scaleway/scaleway-cli/archive/refs/tags/v2.66.0.tar.gz"
  sha256 "8a02b0bfe7fa882884d4438c81240cac30679378afa884471964d3188a49f7d2"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ddafeaf4edb70162cacfbe823da4858a276461c0629a3fe45c14eafb2b98590c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "eaca370c1e605a29999bfb0502102fdabc091d35ccadb8fa9ace28355901312a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c5afe082db64d245fcc0e03080b538857ee7655f7cc59d36255b526ed56bcb1f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "8d64cfdbcfeef77f0ee175e13e8dcf85dfca7a2d04d6ed3c736cf5f36dab9544"
    sha256 cellar: :any,                 x86_64_linux:      "135a9874129a2845f7894b8e5cdb8e7952a5f8e94d58c3767c51a91931b43bdb"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.Version=#{version}"), "./cmd/scw"

    generate_completions_from_executable(bin/"scw", "autocomplete", "script", shell_parameter_format: :none)
  end

  test do
    (testpath/"config.yaml").write ""
    output = shell_output("#{bin}/scw -c config.yaml config set access-key=SCWXXXXXXXXXXXXXXXXX")
    assert_match "✅ Successfully update config.", output
    assert_match "access_key: SCWXXXXXXXXXXXXXXXXX", File.read(testpath/"config.yaml")
  end
end
