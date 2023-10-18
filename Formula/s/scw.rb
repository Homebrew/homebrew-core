class Scw < Formula
  desc "Command-line Interface for Scaleway"
  homepage "https://github.com/scaleway/scaleway-cli"
  url "https://github.com/scaleway/scaleway-cli/archive/v2.23.0.tar.gz"
  sha256 "eff73db40b93e1e034998b0f32f76731213fcb0e6919e7c5d6019f288e3e8d73"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "06e347224d4f50c2d44c6aeb267d7ced0ad23a6f8011b5cd966aeeb7e64a8988"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "501170a5255810fd21811511edce5f27b3a058f3604564755dc380ce6fec8035"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ebf57c0145a603cb32c6507d5e8dba754288df0814e7235fe3e278adb6f28a49"
    sha256 cellar: :any_skip_relocation, sonoma:         "7498e6f90040aa394608079f34448207c9acf5ef2e055ebff7a97ec668638fd6"
    sha256 cellar: :any_skip_relocation, ventura:        "ee010d4bfb95b2e31a4caef77b4a59c62aed2075514a98c146ddf988c7238042"
    sha256 cellar: :any_skip_relocation, monterey:       "3576ae240401771a90f8096b64a2f9aec9846d570a00c1594b4e91182f9e5f94"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a173b7062f4ab3631b13e7e706b7fab6c509fd4b3540f2e8efd732429b7db370"
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
