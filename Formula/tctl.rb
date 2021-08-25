class Tctl < Formula
  desc "Temporal CLI (tctl)"
  homepage "https://temporal.io/"
  url "https://github.com/temporalio/temporal/archive/v1.11.4.tar.gz"
  sha256 "99fc8f4695da9a46f017ebd74cccb567014432aedb4cdfe1aeb97aa010048682"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d5bc139a56ac499cc11173d702fe8164e6577d90fc23e0293855e4977c67f13f"
    sha256 cellar: :any_skip_relocation, big_sur:       "7a1bea8700755b0a5a20808388bb208445a1055d8389a322b9f05899c0bf03c9"
    sha256 cellar: :any_skip_relocation, catalina:      "8c208f377b26fa7b13e37fc6e2573b73e2d9ecb646e36f712db031ad009fe7c4"
    sha256 cellar: :any_skip_relocation, mojave:        "844ff90604eef28c88ebc50097c4ed9b777c25d842d2000dc9ec05bea626e277"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f8147f9e9f8f07ac62a5ec9f09aa9b471725d83776575fdcb3202b3db7f5fad8"
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
