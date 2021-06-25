class Tctl < Formula
  desc "Temporal CLI (tctl)"
  homepage "https://temporal.io/"
  url "https://github.com/temporalio/temporal/archive/v1.10.5.tar.gz"
  sha256 "da8279e8ac5945ddbfbfec9dbefef8d99ac911dc37fc97cf725316239512c72f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "37924da5783ef2e2d98e2f3a4b9234b3d897f8c1953ef897bc4bcd8be79acf05"
    sha256 cellar: :any_skip_relocation, big_sur:       "8a7a41fc295e403dac9ffe4d1d64bf9acfc608141f357aefff02d6f17dcd5708"
    sha256 cellar: :any_skip_relocation, catalina:      "b2e731ae35e8be8f7487e036d8f12dd00004945e93b251b578a9957092792d02"
    sha256 cellar: :any_skip_relocation, mojave:        "e58aead6843469fa73e27cafd97f960cc0c546f031424c95063f7fb4532e7fb9"
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
