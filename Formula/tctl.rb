class Tctl < Formula
  desc "Temporal CLI (tctl)"
  homepage "https://temporal.io/"
  url "https://github.com/temporalio/temporal/archive/v1.7.0.tar.gz"
  sha256 "5b0ec2ff58b5fade97d78157d6ca842a2380374cea2f2c3ab2609a98124cee8a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "98f011f69b121ef976d1ba053103f61b9b4134b643c04fa298a1d6d7a2c1c47a"
    sha256 cellar: :any_skip_relocation, big_sur:       "a626fab774690f8322574d23b3cb2c42ca25e98a421eacd3c12b01f9113f9df3"
    sha256 cellar: :any_skip_relocation, catalina:      "8850a5cf78039211e7c07e3ad6aebeb1d06a2eeb4f1d2953675ffc005fcc755b"
    sha256 cellar: :any_skip_relocation, mojave:        "4b5de8f208b93fcec80cf789bbfbb4269fc64a0252829ed77452a7be928f2300"
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
