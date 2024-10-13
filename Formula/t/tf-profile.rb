class TfProfile < Formula
  desc "CLI tool to profile Terraform runs"
  homepage "https://github.com/datarootsio/tf-profile"
  url "https://github.com/datarootsio/tf-profile/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "9f505b980149c8ffe29089f772391a9230bf6527f18ad56eb158305d752e1ee8"
  license "MIT"
  head "https://github.com/datarootsio/tf-profile.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "04527d6579538a00dd90c798782c63527abf3e9439d2fe9dd1ef200ba68a907e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "40caf3f66f08e25fc07275866f62f83beb5a181cda8e8a669b5de97adc834be5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "55e6cb67d424f1ba45cd147a430d6c8043618af1cd8cd458c7c104b0cd0c1328"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "55e6cb67d424f1ba45cd147a430d6c8043618af1cd8cd458c7c104b0cd0c1328"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "55e6cb67d424f1ba45cd147a430d6c8043618af1cd8cd458c7c104b0cd0c1328"
    sha256 cellar: :any_skip_relocation, sonoma:         "e6cb79f0ab6946769de3dc290e1acd821ed0fb5e6c98e85fd3fc757b3ad3db40"
    sha256 cellar: :any_skip_relocation, ventura:        "ff30b5edb01d8ad7cdd65444dc1b65610a0fa083648a2619196ecb4e162af09b"
    sha256 cellar: :any_skip_relocation, monterey:       "ff30b5edb01d8ad7cdd65444dc1b65610a0fa083648a2619196ecb4e162af09b"
    sha256 cellar: :any_skip_relocation, big_sur:        "ff30b5edb01d8ad7cdd65444dc1b65610a0fa083648a2619196ecb4e162af09b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "44ab3149686e3434357a4ae92e190b9d2f0cd0977c87799a7bc7386d75a5af47"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-tags", "netgo", *std_go_args(ldflags: "-s -w")
    pkgshare.install "test"

    generate_completions_from_executable(bin/"tf-profile", "completion")
  end

  test do
    test_file = pkgshare/"test/argo.log"
    output = shell_output("#{bin}/tf-profile stats #{test_file}")
    assert_match "Number of resources in configuration   100", output
    assert_match "Resources not in desired state         2 out of 76 (2.6%)", output

    output = shell_output("#{bin}/tf-profile table #{test_file}")
    assert_match "tot_time  modify_started  modify_ended", output

    assert_match version.to_s, shell_output("#{bin}/tf-profile version")
  end
end
