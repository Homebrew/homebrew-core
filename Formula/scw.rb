class Scw < Formula
  desc "Command-line Interface for Scaleway"
  homepage "https://github.com/scaleway/scaleway-cli"
  url "https://github.com/scaleway/scaleway-cli/archive/v2.12.0.tar.gz"
  sha256 "6bd8689b9427dc1a1c27099e26e24bf79fda374f058eea84ff8af7e37ae5511a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ce8491542e6161c6e2cc412f332e4a9733d1de1ed6bf35503d7971adb63f8120"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ce8491542e6161c6e2cc412f332e4a9733d1de1ed6bf35503d7971adb63f8120"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ce8491542e6161c6e2cc412f332e4a9733d1de1ed6bf35503d7971adb63f8120"
    sha256 cellar: :any_skip_relocation, ventura:        "894959cd16a05674853d45baa7fb00cfe7ec3ddbff3a0b402e401ac42844d76b"
    sha256 cellar: :any_skip_relocation, monterey:       "894959cd16a05674853d45baa7fb00cfe7ec3ddbff3a0b402e401ac42844d76b"
    sha256 cellar: :any_skip_relocation, big_sur:        "894959cd16a05674853d45baa7fb00cfe7ec3ddbff3a0b402e401ac42844d76b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e06a14f70e9073e240051272c56b0c79da4c41acfaa624c91181ec682ab5395e"
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
