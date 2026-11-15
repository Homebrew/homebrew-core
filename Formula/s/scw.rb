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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "17e91633b2f89f46da9eaa5ed88b59fc07342b864c7cb0ce5317984f746967db"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "cc14a280fe61df22057588e759f6e554cc8b62732da513e844ea526feead6bd4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0dd6a6694ca27669cfb76c60a361bdd9746059b78c2ed5d5021ff60c89e98a44"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ba0f01f75bd191e5e7729c03b1e563c483209a798e6fe613a738a7c4d46a508c"
    sha256 cellar: :any,                 x86_64_linux:      "cf2681cd212de68a8c14d8e0198b847ecb4043f17aa20ade33c8427fac2ed192"
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
