class Temporal < Formula
  desc "Command-line interface for running and interacting with Temporal Server and UI"
  homepage "https://temporal.io/"
  url "https://github.com/temporalio/cli/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "973072f7dd35878572a4db41e202791680c7a743f665f36b41b63a190d5fc2cf"
  license "MIT"
  head "https://github.com/temporalio/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c6b876c24eb39d11b6131b2ceb7228020bf655b71fd1cd5891847c3efa5a8277"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "859ad5445006dabe51ce24b5fc380b74035eb17fe27c02fb43a76b6764a3b9c6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "09e8a5def50d3bfb5f564d156e75e0bc60b0b7a1af679344a2f99b9fc957cd8a"
    sha256 cellar: :any_skip_relocation, sonoma:         "ccfaebdad9bce52f63bee20fc2647bb2846fe4a11a37f0dfdc44bf4ceffd6c32"
    sha256 cellar: :any_skip_relocation, ventura:        "50ac58375c8b1db90a01d7037dadd79b159fdde0a3bf3c6457630fe87e5f46e5"
    sha256 cellar: :any_skip_relocation, monterey:       "436ef471f1775530f47c7d4e2647a29edc92fa2341558345213d0b9f29e4b335"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0678802a07a13341d2877d77b1eb0d090269075388ac0cd30aca9a4c4db0f416"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/temporalio/cli/temporalcli.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/temporal"
    generate_completions_from_executable bin/"temporal", "completion"
  end

  test do
    run_output = shell_output("#{bin}/temporal --version")
    assert_match "temporal version #{version}", run_output

    run_output = shell_output("#{bin}/temporal workflow list --address 192.0.2.0:1234 2>&1", 1)
    assert_match "failed reaching server", run_output
  end
end
