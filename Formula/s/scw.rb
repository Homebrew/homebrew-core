class Scw < Formula
  desc "Command-line Interface for Scaleway"
  homepage "https://github.com/scaleway/scaleway-cli"
  url "https://github.com/scaleway/scaleway-cli/archive/v2.22.0.tar.gz"
  sha256 "1f2b95920871f5f11757526b6e8b13c0de5cbf410014a1bd37d3889ac6a90cc0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3c27558ec639c93e1416f172b54860b9d79a2ee910b57b0e47940f9d0213e3b0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2d723cce675749ad280e479cb8ddc51b2c34d532906f193433c0a1565a36b098"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d56c19a426139bad6305a85407d276aeb801a7ee5c3656107b131187b9cfc906"
    sha256 cellar: :any_skip_relocation, sonoma:         "8c1eb6550101a540f03acb5e5986ae85abf263a32be30c5e524708e0e090fd29"
    sha256 cellar: :any_skip_relocation, ventura:        "f38921e7c28db05ffffd522f1408412acf14812291756c9073179bf7cf78d927"
    sha256 cellar: :any_skip_relocation, monterey:       "0fa8ba6c5cca2c3417b9e3033779d1e50bbf1c6ecf42984fb5ccde5ddbf148b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "caff2480315b3a3a71a9dec7b429a951181bbf9d3d6f9f60ac474656bc3648fc"
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
