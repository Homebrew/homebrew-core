class Scw < Formula
  desc "Command-line Interface for Scaleway"
  homepage "https://github.com/scaleway/scaleway-cli"
  url "https://github.com/scaleway/scaleway-cli/archive/refs/tags/v2.34.0.tar.gz"
  sha256 "ed2c62cffa0a68a4ed973a405eb190e42eb5a1aa3d021ad3729b1301f5646d70"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8f108b3544ed75adf491c64a22317dcd02c5247d9f4ed683d26c449cee955fb5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8f108b3544ed75adf491c64a22317dcd02c5247d9f4ed683d26c449cee955fb5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8f108b3544ed75adf491c64a22317dcd02c5247d9f4ed683d26c449cee955fb5"
    sha256 cellar: :any_skip_relocation, sonoma:        "17e160e945e5405aabd445538119cf31abd27128ec7018dee7270b3de47875a3"
    sha256 cellar: :any_skip_relocation, ventura:       "17e160e945e5405aabd445538119cf31abd27128ec7018dee7270b3de47875a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "96dcc09cad7c0a81f5500848bd47fcdb9526a697d10c0d3a3fda4b3540842cd9"
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
