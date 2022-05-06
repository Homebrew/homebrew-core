class Tcld < Formula
  desc "Temporal Cloud CLI (tcld)"
  homepage "https://temporal.io/"
  url "https://github.com/temporalio/tcld/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "91b56d5f5e4c0a6a36272db31daa1da635156202138bee3ab810be93b82f7301"
  license "MIT"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "-o", bin/"tcld", "./cmd/tcld/main.go", "./cmd/tcld/fx.go"
  end

  test do
    # Given tcld is pointless without a server, not much intersting to test here.
    run_output = shell_output("#{bin}/tcld version 2>&1")
    assert_match "Version", run_output

    run_output = shell_output("#{bin}/tcld -s localhost:1234 n l 2>&1")
    assert_match "rpc error", run_output
  end
end
