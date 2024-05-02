class Scw < Formula
  desc "Command-line Interface for Scaleway"
  homepage "https://github.com/scaleway/scaleway-cli"
  url "https://github.com/scaleway/scaleway-cli/archive/refs/tags/v2.30.0.tar.gz"
  sha256 "5d88f0368848202d777285da7d8379ce1166e8d7c0e97e224c4258dd6b9b0a92"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a9ac5a3958867aab2e0a05133ecd2ce1f9d5feb4560d674a22b20efec9e4631d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dbef9617f3c3e4b2f87ba4a1532949afee56d3dea3cfb05f5478405fb51c04e7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a852dc5d0fb3d3f8e64e1d9baa41c3baf16531138f1670957495c30c3fc4b312"
    sha256 cellar: :any_skip_relocation, sonoma:         "8262c8e7ed4f5cfb598db9384e8a85bff8aae107e965cca4c2a5b024cdd1a9a5"
    sha256 cellar: :any_skip_relocation, ventura:        "b781624bd38e0b9220190c3d98278d4d875866342bcf162c64ad53eebd5df51f"
    sha256 cellar: :any_skip_relocation, monterey:       "b3220f18a517faac537d6cba60ac076626764592f9d5f53b3ed9826cf0a74c04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d3fc8add4ce71d7d530087b068601483e76ee0b12a27ddb0df54452ab8aea189"
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
