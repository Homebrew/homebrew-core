class Scw < Formula
  desc "Command-line Interface for Scaleway"
  homepage "https://github.com/scaleway/scaleway-cli"
  url "https://github.com/scaleway/scaleway-cli/archive/v2.6.1.tar.gz"
  sha256 "4147594e160445910febe0c4efd1d8717a6b89afbe8599393b2aa8462096cb14"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "01ac1f02acb0639e040fc288d2ca3dca24c5ebe44d02b92d3cc610ac7d36030f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7caa446e9fd1da5fba57fc977104a44eb2a98a436eed07739faa9fdb1c64c974"
    sha256 cellar: :any_skip_relocation, monterey:       "1d3a92f59fb0c6f52ad26f108b4b3c3f8af5c607cb87e53d580318d6ddf0de70"
    sha256 cellar: :any_skip_relocation, big_sur:        "ee03674755030d9f6517cc29a379cc016f37d09ddd5a19ebdf66483b9e0df968"
    sha256 cellar: :any_skip_relocation, catalina:       "130d311ea5737583626fb872a7246c451d80f5815b82b1a5057ba18b00416093"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ee9fae42bc801acfbd059e4a0f7650cdf895dd70b68ae0afbc55b38cb498bb38"
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
