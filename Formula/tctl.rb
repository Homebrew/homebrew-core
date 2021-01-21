class Tctl < Formula
  desc "Temporal CLI (tctl)"
  homepage "https://temporal.io/"
  url "https://github.com/temporalio/temporal/archive/v1.6.0.tar.gz"
  sha256 "cb4675725660a060c7de52fa4aab9ca1dff784c46095ea777c4c6e81e9b3d71b"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "544ac03608bb7f81ee4bbb8ddd278cfc9edfac72bb6d58bf5934bd140d5a6e2d" => :big_sur
    sha256 "ccadc7ef85b244ed249bfdf05d5562ee2d5769262635117de1a069a35b561e97" => :arm64_big_sur
    sha256 "6884961bcc2127b758efc784bcb11d1ed011dc88efd5c99f5f4ed0bdd013623b" => :catalina
    sha256 "96c17b53863b45d71c8c895e292a673c27670f22c402732655a7cc5a396cc4fa" => :mojave
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
