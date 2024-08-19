class Temporal < Formula
  desc "Command-line interface for running and interacting with Temporal Server and UI"
  homepage "https://temporal.io/"
  url "https://github.com/temporalio/cli/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "9b6a821e221e832575ddb4a4d972adfe9fde6c51ea4f8cb4e0575b4fcfab2171"
  license "MIT"
  head "https://github.com/temporalio/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e7e5a6383d9aff3b052c4770293cc71298073dda59b87f0c7ac8de0ecce1c959"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a300c69f7bc771058a3c29957b42074258e5cbc3d20578b239905731d5ce5468"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "327071ea09519338ea5f6a9496cc4a407db6807a10018a5f910b9e0b975621a8"
    sha256 cellar: :any_skip_relocation, sonoma:         "276f98c66319173a47e6d7e3fa9a070ec034161f50f746e9533ccbae4e0291ef"
    sha256 cellar: :any_skip_relocation, ventura:        "5edabad597fc53dc846fddfa031331d4b71647b3668261b10dba267958031c50"
    sha256 cellar: :any_skip_relocation, monterey:       "b663f045db5289ba39f5978d338a9da80e7fce68aeb8debb20114f86f99c7499"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5515d54c5d67cd5b33e7933658fc17124ccf8eb347f1a99689acd42dbf8c9d9c"
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
