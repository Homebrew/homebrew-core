class Temporal < Formula
  desc "Command-line interface for running and interacting with Temporal Server and UI"
  homepage "https://temporal.io/"
  url "https://github.com/temporalio/cli/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "ac3b43ff95caf697a9cf2f93294b541524ccc5ad6d5079deac1d60954373bdcb"
  license "MIT"
  head "https://github.com/temporalio/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "277a7b3f055950d9b13457f186e22d76a3463c509bfeea239c5cd8c75375bdee"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "784c78d3607aee431cb2b73538fb0df3fc4a0f8c6aa49167af881a34ecd013fa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9eae4e7332f7467c927795cca95cfe566f0a04e3d02ce272a3e4e073c3d50c54"
    sha256 cellar: :any_skip_relocation, ventura:        "48f19833c3fb325c3fb08a317e33c6279ed1696492ea3f0a749a4792630d6529"
    sha256 cellar: :any_skip_relocation, monterey:       "10e9f1cf373aa6a3389f3691521f487ac20607924940d415420caa932519ce9c"
    sha256 cellar: :any_skip_relocation, big_sur:        "afdce207e2aa44331f494b48630285cf5b5c124753df9c8bdf5f60310d6e7a6d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "746b02a7fa80732f169cec4c929fd5d7a0b9cf3062c2c804c71f43ca2749b9cf"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/temporalio/cli/headers.Version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/temporal"
  end

  test do
    run_output = shell_output("#{bin}/temporal --version")
    assert_match "temporal version #{version}", run_output

    run_output = shell_output("#{bin}/temporal workflow list --address 192.0.2.0:1234 2>&1", 1)
    assert_match "failed reaching server", run_output
  end
end
