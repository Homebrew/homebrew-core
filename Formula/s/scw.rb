class Scw < Formula
  desc "Command-line Interface for Scaleway"
  homepage "https://www.scaleway.com/en/cli/"
  url "https://github.com/scaleway/scaleway-cli/archive/refs/tags/v2.42.0.tar.gz"
  sha256 "40cafbdedc8b956a4b7da331bae7c6ec26f891a40e789348d36bcddea9c88ee3"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6dc79e30247d27ba01f9e05df2eb24e87b0b5d912e90fc5fb5c99dc4291dc937"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6dc79e30247d27ba01f9e05df2eb24e87b0b5d912e90fc5fb5c99dc4291dc937"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6dc79e30247d27ba01f9e05df2eb24e87b0b5d912e90fc5fb5c99dc4291dc937"
    sha256 cellar: :any_skip_relocation, sonoma:        "83199586064565fe25826b78a51a017516fdc58d00c295bd5b20d10b65b73c57"
    sha256 cellar: :any_skip_relocation, ventura:       "83199586064565fe25826b78a51a017516fdc58d00c295bd5b20d10b65b73c57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "43d401dab22332e8e8aee3559b9c8615aab80bf726f1bfb43dbd7f5b3a61935c"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}"), "./cmd/scw"

    generate_completions_from_executable(bin/"scw", "autocomplete", "script", shell_parameter_format: :none)
  end

  test do
    (testpath/"config.yaml").write ""
    output = shell_output(bin/"scw -c config.yaml config set access-key=SCWXXXXXXXXXXXXXXXXX")
    assert_match "✅ Successfully update config.", output
    assert_match "access_key: SCWXXXXXXXXXXXXXXXXX", File.read(testpath/"config.yaml")
  end
end
