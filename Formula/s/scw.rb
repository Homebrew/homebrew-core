class Scw < Formula
  desc "Command-line Interface for Scaleway"
  homepage "https://www.scaleway.com/en/cli/"
  url "https://github.com/scaleway/scaleway-cli/archive/refs/tags/v2.66.2.tar.gz"
  sha256 "e75a410a2edff855acbb309009fb6d571c92fa738f736586d392da2fdf9d3b0b"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "702656c6f41d2f9c1f14bc1418f82a920b3d59271b154b258b837202e1ffdd10"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9a4ae8347b2e5637ba2a8557680513945dd0605b8c2f3d8d475645bd7c1a0fd7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f8e437934db318c9c5f67dd36865276c0dd778c8a6ba4459c3407151f1cfa5c8"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "31d8535aa42a08555262133f9942b07724a6d6831add515886630939e19f24eb"
    sha256 cellar: :any,                 x86_64_linux:      "70a7957cb91edceb78deacf7d6b9e3003ec337b757c29c384606bb2f733321f1"
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
