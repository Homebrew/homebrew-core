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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "73e283ec68c97dfe82a8c41403e5ea22deda6020c5f07e472285ea5db95b3280"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8fbf1d3d7c2978861c7a23ff10b765588f9824234ba79daac4b9b4b7e9782009"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "da09c60715458b2a2195e40cb05df42f5de3615f0515a085465baae9a3077616"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "695941f646abd25e0a83a5492eb9481b85132a45d35bf141221b7743d150b026"
    sha256 cellar: :any,                 x86_64_linux:      "f214e69ec9543d85239047695ac7eb3d7e75c956ea08dfe1ee105e540a6fbd5a"
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
