class Scw < Formula
  desc "Command-line Interface for Scaleway"
  homepage "https://github.com/scaleway/scaleway-cli"
  url "https://github.com/scaleway/scaleway-cli/archive/v2.8.0.tar.gz"
  sha256 "ed5a0a22f6d788fdf91839ac362c7ae4352f9c37e1687187282e0f863f5663ba"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6fc0a84e6b6a786d0ffce4077ac91b61c7a87e01c2795723d5d30fd183af638b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "409baa8ee83d8c8eca93b351c7bff02b9e1f0622276f69ddb3019324fcbc24f5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "36d1d6e1916668bd4ddc00d54a2e907983d1ed1fde48e0d0eb6f9102683b441e"
    sha256 cellar: :any_skip_relocation, ventura:        "a1e51d947ed3ae8371928d9970fe86480e32984fae8d7a297d7632959724b786"
    sha256 cellar: :any_skip_relocation, monterey:       "8b52b776b353b7ece16c94c043e6a5b7bf8e0c4868ebff82bb378dccb7f61aa7"
    sha256 cellar: :any_skip_relocation, big_sur:        "b77557d71d1695f1d8925be07d756e568b6415c5275ebc0ea0a2fcb9c54ece1d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d85dd79a00535623104e76725cf2f0ff984c5e96cd54bc0a75e4c67ac954f511"
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
