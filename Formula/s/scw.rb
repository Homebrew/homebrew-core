class Scw < Formula
  desc "Command-line Interface for Scaleway"
  homepage "https://www.scaleway.com/en/cli/"
  url "https://github.com/scaleway/scaleway-cli/archive/refs/tags/v2.45.0.tar.gz"
  sha256 "8c9d56d752d06e35abccb0f626e7df2418a17a22b27cb1a49a2638370f0f2c83"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b3054814254594e5aab105799dc85dac4228a5cc858a91b55ad79209996d4be9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5b353927d8d7d5180070e48d41806c3a298907dcff412cf5315ac9616a6511e3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "23d0216cfc5eb9f83e67d35332f288fb866beae50f5379ab3ed0c807f01d8913"
    sha256 cellar: :any_skip_relocation, sonoma:        "2f6ff88bebbae4a0c7930ae3840d9aa8af45a436d19eeae7f865ffd1577c91b8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "372d442ec10bbb3403b0186183daf09fea71b3db3b8ef883def60a24795b2629"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "95482ec1a41ace1af329f242dcec428d0a112b22a5eb43fad5783818c0d9c788"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}"), "./cmd/scw"

    generate_completions_from_executable(bin/"scw", "autocomplete", "script", shell_parameter_format: :none)
  end

  test do
    (testpath/"config.yaml").write ""
    output = shell_output("#{bin}/scw -c config.yaml config set access-key=SCWXXXXXXXXXXXXXXXXX")
    assert_match "✅ Successfully update config.", output
    assert_match "access_key: SCWXXXXXXXXXXXXXXXXX", File.read(testpath/"config.yaml")
  end
end
