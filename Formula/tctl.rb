class Tctl < Formula
  desc "Temporal CLI (tctl)"
  homepage "https://temporal.io/"
  url "https://github.com/temporalio/tctl/archive/v1.16.3.tar.gz"
  sha256 "c2d49e88391390b89fb1e3e99ecb34d61d0daceddbe2aa1e6b5df491355a8ee3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7e0789871abb3a59da9068c86fe7bd8d2a20a68271d8cad9553e5a3848337eec"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6d6f6cc45c72e0bf3fd35638f11bb0cc6e0a5e01e4fe8d4596294f5a7be80df1"
    sha256 cellar: :any_skip_relocation, monterey:       "bf6399552b84a7468ea245577d15a3170b134d431ee8ee469961f7e1d121991d"
    sha256 cellar: :any_skip_relocation, big_sur:        "009daa178e9d9ed54b334fed561f1d4d4a51a23f0c80f7b6a38d0ada8b90055e"
    sha256 cellar: :any_skip_relocation, catalina:       "896181bfb23b52b2e3d1b31446749cb42086cd879bb74d99ae317083d204dfc3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "40684a53b19b410377a9f6ba47f778bf38d7b89a908c07b087268445c8015d22"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/tctl/main.go"
    system "go", "build", *std_go_args(ldflags: "-s -w"), "-o", bin/"tctl-authorization-plugin",
      "./cmd/plugins/tctl-authorization-plugin/main.go"
  end

  test do
    # Given tctl is pointless without a server, not much intersting to test here.
    run_output = shell_output("#{bin}/tctl --version 2>&1")
    assert_match "tctl version", run_output

    run_output = shell_output("#{bin}/tctl --ad 192.0.2.0:1234 n l 2>&1", 1)
    assert_match "rpc error", run_output
  end
end
