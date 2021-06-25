class Tctl < Formula
  desc "Temporal CLI (tctl)"
  homepage "https://temporal.io/"
  url "https://github.com/temporalio/temporal/archive/v1.10.4.tar.gz"
  sha256 "253a61cda4910bddfacb8db33ffc2b697ed862d4f2d008ce00f49391c9a19fd4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d230a317dbfd06a3c258e4290a099bf46788db30ecaba3918d54cadf8fd9bd96"
    sha256 cellar: :any_skip_relocation, big_sur:       "dd055f795a139935079afd93b54ef910a024d5c7c05c8ecd86f3a457164f66c7"
    sha256 cellar: :any_skip_relocation, catalina:      "72e452b3b494e9022ea27581028fbe1b73e9eef47139232f0bb15b82720e2470"
    sha256 cellar: :any_skip_relocation, mojave:        "5cce7c20db96b5148ce4f07e97ae13a292b93498a8cc7c6027ef50adad4b1afd"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags", "-s -w", "./cmd/tools/cli/main.go"
  end

  test do
    # Given tctl is pointless without a server, not much intersting to test here.
    run_output = shell_output("#{bin}/tctl --version 2>&1")
    assert_match "tctl version", run_output

    run_output = shell_output("#{bin}/tctl --ad 192.0.2.0:1234 n l 2>&1", 1)
    assert_match "rpc error", run_output
  end
end
