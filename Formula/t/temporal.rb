class Temporal < Formula
  desc "Command-line interface for running and interacting with Temporal Server and UI"
  homepage "https://temporal.io/"
  url "https://github.com/temporalio/cli/archive/refs/tags/v0.10.6.tar.gz"
  sha256 "1a8f1fef8e58e3bb431901f328ca492790fc5c716f2af19b0d00754a85283604"
  license "MIT"
  head "https://github.com/temporalio/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f2a7a82e2600ab7e17a99983ad1dde7fbaef98f739672366be5373a42cb1e570"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0d1043e1407d222b12d4b20d8a1c1b883289350708e8ff7abfc7e1b156d52df4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9e3d2697fce585c1056db59ce7c70bf6ee7095cdbecd9b5b67086ec6b52b4d2f"
    sha256 cellar: :any_skip_relocation, sonoma:         "accc3961247fa126ff0ba2681a2a3564987018c9535cc4bb490ceed05fdc66df"
    sha256 cellar: :any_skip_relocation, ventura:        "2fc7e439b8c765da451144a1bc0a41c86c02677151224f4992faf407a7103901"
    sha256 cellar: :any_skip_relocation, monterey:       "91b7f91aea2f75c7e6807c99d8bd5f2b5843760da546a616dd96856b7fb4fdeb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8977e4871bb3d50ef59e75fd9670729c9d218ea0482ca16ac9be48c1d7f8cceb"
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
