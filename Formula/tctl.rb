class Tctl < Formula
  desc "Temporal CLI (tctl)"
  homepage "https://temporal.io/"
  url "https://github.com/temporalio/temporal/archive/v1.14.5.tar.gz"
  sha256 "332520a6eb2b64199a4ceda43eb19b7a8831f9bb4d15c3a4c043b8f53d9e91f5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5ac8d50f8cf0716f1bccfe68f95639ae4274b85676ee1e485b9f9d68717095a1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6afb2d67b5f3d542544ef5cf8aaa335838146dedb28abef0b6483c2fde9141ed"
    sha256 cellar: :any_skip_relocation, monterey:       "37c0a8369506945856e40b8cf3f2501ec78d7f2d8aaf54ebc850c3f6e72a2ab2"
    sha256 cellar: :any_skip_relocation, big_sur:        "03cca3e3b523dbd06bd63c494404adfd45d0f3d975164810e2f2c1d7156a2f62"
    sha256 cellar: :any_skip_relocation, catalina:       "bf4d74fae7cccddc97cd0db52388b5c5adedd192fdc919fae0491073353b2143"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7489a5013dcced8ec9b710aa195c5d08e2b9f0d8475018fc1aa12e87e818d833"
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
