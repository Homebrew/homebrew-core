class Tctl < Formula
  desc "Temporal CLI (tctl)"
  homepage "https://temporal.io/"
  url "https://github.com/temporalio/temporal/archive/v1.11.3.tar.gz"
  sha256 "2d41a6ff696c4ee007df39cce5f40fde57b0e1becdb66c88f4a4ca689a933d99"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "0247ac03f42c0640b03cdecd8069009f2071dee5c37962e323cfb13d0ed69ea3"
    sha256 cellar: :any_skip_relocation, big_sur:       "09f4749fb75001a1bbe087980e0d168f360ca31fdc094d0b544314371e5515db"
    sha256 cellar: :any_skip_relocation, catalina:      "415def0b7648286bb4895c251b6de925b73dd2549f2d582ae3ca6cc6afd6908a"
    sha256 cellar: :any_skip_relocation, mojave:        "c4e8cc60aea8c9ac3b968f752e2db46e1472b20d860cb29674111d490611fde0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cba7ffde64faf052bb69a0d0328153422501f064d86584440f50a5416fb9950b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/tools/cli/main.go"
    system "go", "build", *std_go_args(ldflags: "-s -w"), "-o", bin/"tctl-authorization-plugin",
      "./cmd/tools/cli/plugins/authorization/main.go"
  end

  test do
    # Given tctl is pointless without a server, not much intersting to test here.
    run_output = shell_output("#{bin}/tctl --version 2>&1")
    assert_match "tctl version", run_output

    run_output = shell_output("#{bin}/tctl --ad 192.0.2.0:1234 n l 2>&1", 1)
    assert_match "rpc error", run_output
  end
end
