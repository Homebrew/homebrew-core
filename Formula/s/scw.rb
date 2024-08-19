class Scw < Formula
  desc "Command-line Interface for Scaleway"
  homepage "https://github.com/scaleway/scaleway-cli"
  url "https://github.com/scaleway/scaleway-cli/archive/refs/tags/v2.32.1.tar.gz"
  sha256 "4b2bfe7b39dcb259f27d5e4eaae4ffc55f31fb9cf6ff1869c7783c5d75c66eb6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ba8dbce4a9c135c42885e93ade29d1817f00e88a6bda3b101bf9968063712cab"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "84491ee62d9ef345ac1e508228eff7e74450019592069e81a9d1b1e1ac28173f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "655842d80916a20251c82431363c5701f9c10bad2c84093d598317d3a71df159"
    sha256 cellar: :any_skip_relocation, sonoma:         "101ad0b59d1d16c72eebb1e3d9acf0fc5ad6c466f11624073d04fe67b58d326c"
    sha256 cellar: :any_skip_relocation, ventura:        "214da6449475ce27a1222d78d3e6252cc4880ec8d290e76ef5062bc1e6881886"
    sha256 cellar: :any_skip_relocation, monterey:       "e20bbd48e607d7e611063f8a3a2f008fc4949bb41f87871f0e2706960d33199b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "544312c785a0fa1a14331035fb191b8972579e9ce15e4c5fd46e4dce855c28b2"
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
