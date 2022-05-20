class Tctl < Formula
  desc "Temporal CLI (tctl)"
  homepage "https://temporal.io/"
  url "https://github.com/temporalio/tctl/archive/v1.16.1.tar.gz"
  sha256 "ba5bccd462e974689a9601716dc9168d6e5ce9b6109d85278684975d7fe7e5ec"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "470cb1dfb2cb2530fc3c966d95ff6ff4bf939a2994659c439f1ee998e640de50"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ecb47cc696305a9b63b73cddd67343e9ad81a8f4d471f48d417a3202365b555d"
    sha256 cellar: :any_skip_relocation, monterey:       "f5254f93d38b1c8416ab402da1349059075f86c7d16e56c63d9fc6436643e88f"
    sha256 cellar: :any_skip_relocation, big_sur:        "62136434bd416c2edc46d891fb48ac3bf0a60fe57f5a357b23bcff90f4c0a6b2"
    sha256 cellar: :any_skip_relocation, catalina:       "9f891235816c98e033c44d9836fddcb5dc226df716db3615f03262a523aaa5b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b98127102b4d6cca64f9a827f41abc18d6be87e3c14e2a62804201162b3dcfe2"
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
