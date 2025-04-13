class Temporal < Formula
  desc "Command-line interface for running and interacting with Temporal Server and UI"
  homepage "https://temporal.io/"
  url "https://github.com/temporalio/cli/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "15be9f155cd5114367942568f884969f7ed2d3262ad39bb665cf359735f643b3"
  license "MIT"
  head "https://github.com/temporalio/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "09c10245895b57422b1219614ec7be544e4df82a4b57bda331cf39acf45727bf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ea029f857617c9e48af3e5b0822f0a39db4c116e162e2efb7559cc997d1f2bf0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "57a33387e038bcd36cd04e49408da28021ba1c61a6b79548ffc519e7647fe209"
    sha256 cellar: :any_skip_relocation, sonoma:        "5a585e98279e6261a4075d3d8b738d81506cdc85bfa7dbf6bc75e095d38206d8"
    sha256 cellar: :any_skip_relocation, ventura:       "f371c0dd1374e2069f2d74fc11eb7009f9997bc885d5d364fa0ca99f3f108417"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "70673fc01d535b2e9d368ac711c32ccd62538c2d90f390f8c1c350b604571205"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/temporalio/cli/temporalcli.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/temporal"
    generate_completions_from_executable bin/"temporal", "completion"
  end

  service do
    run [opt_bin/"temporal", "server", "start-dev"]
    keep_alive true
    error_log_path var/"log/temporal.log"
    log_path var/"log/temporal.log"
    working_dir var
  end

  test do
    run_output = shell_output("#{bin}/temporal --version")
    assert_match "temporal version #{version}", run_output

    run_output = shell_output("#{bin}/temporal workflow list --address 192.0.2.0:1234 2>&1", 1)
    assert_match "failed reaching server", run_output
  end
end
