class Terramate < Formula
  desc "Managing Terraform stacks with change detections and code generations"
  homepage "https://github.com/mineiros-io/terramate"
  url "https://github.com/mineiros-io/terramate/archive/refs/tags/v0.2.4.tar.gz"
  sha256 "6c22906faade556a4037965c2c2618d01f43900e07da9cf676b8bf328420f11d"
  license "Apache-2.0"
  head "https://github.com/mineiros-io/terramate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "08c981c0ecc2774f3c22371107191d23f58d20d5f1017eee1fad8c5d24cf042c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a71db6558c1aeed1ed88be9238db4d65adb58d6909f635f12d19dd490205816d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "55ad6226a8735a33fca474b45248e0c601bcbee333b31a50a93ca855c65bf3d3"
    sha256 cellar: :any_skip_relocation, ventura:        "3667fb7d2ada2d696f777c3a6535ecddfb4164a36a587c4c4f16b2c03e8a64ae"
    sha256 cellar: :any_skip_relocation, monterey:       "f5bd7c11d823eb55d3efbefc9583dbd8c7f8bc569b518f08ff2735cdd7d4510f"
    sha256 cellar: :any_skip_relocation, big_sur:        "5c42dac890af3f93bf9f047cba0d4249d011c436ea3483d37eb4c38061d26961"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e2d94ec208e8fc063cc1e3643864de015e259c528273deadfd4c0e5fc68c1637"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/terramate"
  end

  test do
    assert_match "project root not found", shell_output("#{bin}/terramate list 2>&1", 1)
    assert_match version.to_s, shell_output("#{bin}/terramate version")
  end
end
