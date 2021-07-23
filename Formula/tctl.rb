class Tctl < Formula
  desc "Temporal CLI (tctl)"
  homepage "https://temporal.io/"
  url "https://github.com/temporalio/temporal/archive/v1.11.2.tar.gz"
  sha256 "9ee41abe22bfeb6d54a91307506699b8d36069344c5535479640876ca946fa64"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "232636a789873fd1388522d20128b9a737ef10f8d0b39017ed1ee1e8192a02a0"
    sha256 cellar: :any_skip_relocation, big_sur:       "2cec0fdb9aa3711b252cb4c6f799001882933bacf3fcafd7b5c577df032677a7"
    sha256 cellar: :any_skip_relocation, catalina:      "3e5510a225655a11ed98f875ede9d259fc12f7a0b62eba971a5f56157398bf1e"
    sha256 cellar: :any_skip_relocation, mojave:        "65d28884892c3ce1da8203f0013c2629d46f1fe37c323e2875140e9544e5172d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "42f0ceb0920d53106e21815a4b388c3f61ab604550fbb8c0d42e1d6917c4524a"
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
