class Tctl < Formula
  desc "Temporal CLI (tctl)"
  homepage "https://temporal.io/"
  url "https://github.com/temporalio/temporal/archive/v1.6.3.tar.gz"
  sha256 "95c5955511024610cd71c56c167497fc1eccd1f0ea4ebe7643f6153acdf76d10"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "3c4b5b83249be1f4762af8a7c2a3e2104cd6a9d2593212434ca6c74d00592768" => :big_sur
    sha256 "84c46b6424e6f5ff70f23a1b70969fc30b949352ca4cb1aaa6164e669f17483c" => :arm64_big_sur
    sha256 "6512c8b762782c1e9928e7c459306dd63d9facf8c3ed2d34838588cafca0607e" => :catalina
    sha256 "99f7c4b5f731f0f42a2e0df2e2fe73fd0385f1e42b2400f3ad12769b8a07fadb" => :mojave
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags", "-s -w", "./cmd/tools/cli/main.go"
  end

  test do
    # Given tctl is pointless without a server, not much intersting to test here.
    run_output = shell_output("#{bin}/tctl --version 2>&1")
    assert_match "tctl version", run_output

    run_output = shell_output("#{bin}/tctl --ad 192.0.2.0:1234 n l 2>&1", 1)
    assert_match "rpc error", run_output
  end
end
