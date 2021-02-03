class Tctl < Formula
  desc "Temporal CLI (tctl)"
  homepage "https://temporal.io/"
  url "https://github.com/temporalio/temporal/archive/v1.6.3.tar.gz"
  sha256 "95c5955511024610cd71c56c167497fc1eccd1f0ea4ebe7643f6153acdf76d10"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e4f69110a40dffd2031ac1f390dd2cbddf9ba90d9128b15e8b05c69b39d883d7"
    sha256 cellar: :any_skip_relocation, big_sur:       "b8f9411009a0d558cdd33c6d9ae389e16b13db22ebff1b25aefa81ece08e4a4f"
    sha256 cellar: :any_skip_relocation, catalina:      "e64636698c15db730d04618bf2fe78756bf0a4be0dce3a4af85b8f9bb62cd471"
    sha256 cellar: :any_skip_relocation, mojave:        "c39f56bf3f4509057595019081a639f6e7f03c9884bc89bac89d4bacb76001f0"
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
