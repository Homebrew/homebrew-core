class Tctl < Formula
  desc "Temporal CLI (tctl)"
  homepage "https://temporal.io/"
  url "https://github.com/temporalio/temporal/archive/v1.6.0.tar.gz"
  sha256 "5d989c279613046bad2956522558cf94125f2a08b77864ffe802c3a7f8e41a56"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "77311371e3e7359723f02e3a2d8871c2ff72c948b2f54034de4e86468cf3ef1e" => :big_sur
    sha256 "ca24c6d4fd9d5dbd47c8e4398b0f69649a1c234890fdab1d11a63e27f6863168" => :arm64_big_sur
    sha256 "122c79493d6fa1daad6d12fccbe4126adb08de9a664a983fbfe4b26a3a499af7" => :catalina
    sha256 "24ba425dc2c16aa1360a3e9a28fd31d065397aa00adb3c871e51a1f82589df29" => :mojave
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
