class Tctl < Formula
  desc "Temporal CLI (tctl)"
  homepage "https://temporal.io/"
  url "https://github.com/temporalio/temporal/archive/v1.14.1.tar.gz"
  sha256 "25beb6f8731f772adc73a24034c764ee9ab29a2ef2d85a53acbabf27342452bd"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "568737fb8fb0e7ebdcd04c36316d56b0c260fe84fad05d5330b7c446e3f0d3d7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b3a2982b2a5e29d483af1f4b089021c169b99f8eba9b03e0e5776e03812fa40b"
    sha256 cellar: :any_skip_relocation, monterey:       "e69a94d70fd2ff3815b6190a4b8d496642e1dac0dc75d24dea2d35bea690d34b"
    sha256 cellar: :any_skip_relocation, big_sur:        "b164da4b9615731fac98ba0bad82217140368a3788a18d422ed3b0f3e134a940"
    sha256 cellar: :any_skip_relocation, catalina:       "772ad6f9ba179cd37a5fbaa91c0c4b8738b858bde36274954661696166b0dbde"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ef822b471acbf65a0f11192f8ad4795a62648d22c666122980f71f7cefd3ff8f"
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
