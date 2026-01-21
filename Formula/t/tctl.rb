class Tctl < Formula
  desc "Temporal CLI (tctl)"
  homepage "https://docs.temporal.io/cli"
  url "https://github.com/temporalio/tctl/archive/refs/tags/v1.18.1.tar.gz"
  sha256 "945272db4860e3a015e43b4ffc8fc24ecd585e604f4b94b3a964d2f4e51b9c32"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "c12ec8c0ad2ef4cca609b9df65b2056e85651857e322e8015b1b9d323b5650bc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "7820bd1e43e2d0b5fbbbf20ac2592642c42d2085c2f8ec4c96a98ec609fb6a35"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ac5e8aca07861abbfb56081050cfb6faa543a8ccb5ce8c800b5f0197de90cbfb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aa22864d02f9260322e70777bdf2cb834e697a1bcddd49a84211a7030d743bf3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ac4a78dea7bbb2f643e8db88ab808abd9ecaf6c9363017c65346a28a3a4b5e38"
    sha256 cellar: :any_skip_relocation, sonoma:         "081280cf31bbf2fc09c433ad8e5e3f8368c720b0fe51f303fa2bc04940333683"
    sha256 cellar: :any_skip_relocation, ventura:        "2086b0e1d687f32df0b3b72951f7e647e6d53dc87633f3b58bc7e7c8b1e3cd74"
    sha256 cellar: :any_skip_relocation, monterey:       "888e39c95e804081f11c4da9a0c62535a91e18cafbf661e3b1f7203082c1957c"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "5c4e8c844a0839abe2e32c2ac60826765819e9e79e1f63f5f27b6291acab48e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6fe6c1efa47cbfe9750cb68e0c9e413a4e2005d382faf3554202585f71218500"
  end

  deprecate! date: "2024-12-04", because: :unmaintained, replacement_formula: "temporal"
  disable! date: "2025-12-04", because: :unmaintained, replacement_formula: "temporal"

  depends_on "go" => :build

  conflicts_with "teleport", because: "both install `tctl` binaries"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/tctl/main.go"
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"tctl-authorization-plugin"),
      "./cmd/plugins/tctl-authorization-plugin"
  end

  test do
    # Given tctl is pointless without a server, not much interesting to test here.
    run_output = shell_output("#{bin}/tctl --version 2>&1")
    assert_match "tctl version", run_output

    run_output = shell_output("#{bin}/tctl --ad 192.0.2.0:1234 n l 2>&1", 1)
    assert_match "rpc error", run_output
  end
end
