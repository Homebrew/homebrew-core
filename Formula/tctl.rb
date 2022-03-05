class Tctl < Formula
  desc "Temporal CLI (tctl)"
  homepage "https://temporal.io/"
  url "https://github.com/temporalio/temporal/archive/v1.15.2.tar.gz"
  sha256 "37702b1e22fc37fb83f0e00627c91703bed62fc296ae580298f6b19c5bc4dd9e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2e4240bbc07b97756fc3f1ecdc2b7e95ce8fb0cc970403b9eed70fbccf8f0610"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7a8048df26b666f00b1d156e2f4f2a1b1385863f40e920a47867566707e257c6"
    sha256 cellar: :any_skip_relocation, monterey:       "356d83e582706a634b1c825a3b9b032ad5a90302b760258d54aa499a008dbc83"
    sha256 cellar: :any_skip_relocation, big_sur:        "886b1f942c7306462db0cb0ff16dcda361a9d4990bf66673371b34654e0c9ee7"
    sha256 cellar: :any_skip_relocation, catalina:       "a1d090b4e81006160294e526b2a291aa82fbc2cc8c8b23835805a089778b3b65"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b06bec1ccd4f815cacac985377b32dcb069d0ce42784b969b28ec225f52b1508"
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
