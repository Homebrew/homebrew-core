class Tctl < Formula
  desc "Temporal CLI (tctl)"
  homepage "https://temporal.io/"
  url "https://github.com/temporalio/temporal/archive/v1.15.2.tar.gz"
  sha256 "37702b1e22fc37fb83f0e00627c91703bed62fc296ae580298f6b19c5bc4dd9e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "65a3da1228cafd6dfe643c65326438ace55a1cf831b3bea8656defe38997c59b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4bf5121066c3158be1b3a1b395d5f924213f5d0853e3a601be3c727a4d8af10d"
    sha256 cellar: :any_skip_relocation, monterey:       "0895f3f184a242b32aab190af23feb295c3ab7bdde2aefd2780a5e6fab6e984b"
    sha256 cellar: :any_skip_relocation, big_sur:        "a806aed178d2297ee395cf80aeec1f07b09369493b98d221b7df51dd0e697548"
    sha256 cellar: :any_skip_relocation, catalina:       "8316ca9671ab2b6a6e78c94c68039f76874944bca4e2ae02f65e0c1467f90d01"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "719fe7a41933a78d59a0416babd4de7d19f2ef93437173ebebec3a0fdc91454c"
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
