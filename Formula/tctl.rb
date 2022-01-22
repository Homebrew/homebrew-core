class Tctl < Formula
  desc "Temporal CLI (tctl)"
  homepage "https://temporal.io/"
  url "https://github.com/temporalio/temporal/archive/v1.14.4.tar.gz"
  sha256 "9a2b2cab4e7d0217917f2d8d0f838d030ad8f59219f185a47eff5f2efb485d5a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7d9d7059c3c5dff3ed0c753b2eec084b26f92a1864ea2a953f9f0170e176c209"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "00bdde9744dee4fcfab6c36d98dc8a5c9f8202858c9a4da37f638123735ea2f9"
    sha256 cellar: :any_skip_relocation, monterey:       "8a69766cf03c76af4647f3e5db4e29bcc891badf0558e20ae375ca70449d4ba6"
    sha256 cellar: :any_skip_relocation, big_sur:        "b0dc835dc6d38cf6b2ebac360c37b4a890ebe6faed703f748ba637f204b67fd5"
    sha256 cellar: :any_skip_relocation, catalina:       "730386fbe040697391a1d9b64e5acfb2d5a0e9a1ff900559bdaf7a77a0d0e052"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b015df3ad3cba35af816b19f2d39d56eab1b7194e02d981a9389c790f6385965"
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
