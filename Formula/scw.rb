class Scw < Formula
  desc "Command-line Interface for Scaleway"
  homepage "https://github.com/scaleway/scaleway-cli"
  url "https://github.com/scaleway/scaleway-cli/archive/v2.6.1.tar.gz"
  sha256 "4147594e160445910febe0c4efd1d8717a6b89afbe8599393b2aa8462096cb14"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f9ac40f5ef4b4ea5ddce9bf94c77e19d0fc0f794c7ea91d255ab12d51b32515f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "60e7142638f3e53f3ca42ed1a0fc13b5286ee0bb233cf9242506b2360e35e19c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5567c4db5591d68a9bc1983be90d45c288fb429b442052113034e1b4333fe6bc"
    sha256 cellar: :any_skip_relocation, monterey:       "c50cb31325282bc3054470f65e2aa73815364eb24197326c4e767ac0141f8a84"
    sha256 cellar: :any_skip_relocation, big_sur:        "b4089297452aec2c0e7bec1719d0c36fb5287971aac4347e868454c6cec4b023"
    sha256 cellar: :any_skip_relocation, catalina:       "dbc92dfb3eeed9599fa452eccb8a0a2f1f979878e38dd09da64614d2824ff820"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a728bae021815693bbc71bb90417bd656a0f783621c6e3404ae66dfb5be9067a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.Version=#{version}"), "./cmd/scw"

    generate_completions_from_executable(bin/"scw", "autocomplete", "script", shell_parameter_format: :none)
  end

  test do
    (testpath/"config.yaml").write ""
    output = shell_output(bin/"scw -c config.yaml config set access-key=SCWXXXXXXXXXXXXXXXXX")
    assert_match "✅ Successfully update config.", output
    assert_match "access_key: SCWXXXXXXXXXXXXXXXXX", File.read(testpath/"config.yaml")
  end
end
