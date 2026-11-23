class Scw < Formula
  desc "Command-line Interface for Scaleway"
  homepage "https://www.scaleway.com/en/cli/"
  url "https://github.com/scaleway/scaleway-cli/archive/refs/tags/v2.67.0.tar.gz"
  sha256 "164506f9dad5873eb3e18abd349f849ec35e77bcb9346b29c47e2a9bbee5a9b9"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    manifest_sha256 "568bcb2a91b90989928285e5604d697e907e10dc48a3ed0c98f3863420ecb1fc"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "96b33a7273beef72c45ba0faefbf8463649a05ad567e96cf1e3dd19e40af1d3e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "995c39a4f93d2a0136e642dd86cab43bd25db86cf36d3693ca9ce42d42de4736"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ecf053df88a2f302319bbba429728ecf9abcc3d1c1055547a63d065c9ff3c1d7"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b9e64123112601e1fe2078076f0ad3029ede99c36684175dd8433b163b81aec3"
    sha256 cellar: :any,                 x86_64_linux:      "184f80364cc05349d109e922392e60289fdd53df4bdae5f414aef644b5137a3f"
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
