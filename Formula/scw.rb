class Scw < Formula
  desc "Command-line Interface for Scaleway"
  homepage "https://github.com/scaleway/scaleway-cli"
  url "https://github.com/scaleway/scaleway-cli/archive/v2.12.0.tar.gz"
  sha256 "6bd8689b9427dc1a1c27099e26e24bf79fda374f058eea84ff8af7e37ae5511a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f923ac968514d17b3f05623a7b40e162b7e0f0e587591bd8e1fc6733654c4919"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f923ac968514d17b3f05623a7b40e162b7e0f0e587591bd8e1fc6733654c4919"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f923ac968514d17b3f05623a7b40e162b7e0f0e587591bd8e1fc6733654c4919"
    sha256 cellar: :any_skip_relocation, ventura:        "e93cb4d02f830130c60d08997531620fdb81720ecc3c2cf4342c6676bf6441a3"
    sha256 cellar: :any_skip_relocation, monterey:       "e93cb4d02f830130c60d08997531620fdb81720ecc3c2cf4342c6676bf6441a3"
    sha256 cellar: :any_skip_relocation, big_sur:        "e93cb4d02f830130c60d08997531620fdb81720ecc3c2cf4342c6676bf6441a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5f9abe1d912bf30a4f3e578c88ab7aa0fdca8d0fa10123103f84f97db01369be"
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
