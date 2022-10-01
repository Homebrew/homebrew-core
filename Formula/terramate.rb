class Terramate < Formula
  desc "Managing Terraform stacks with change detections and code generations"
  homepage "https://github.com/mineiros-io/terramate"
  url "https://github.com/mineiros-io/terramate/archive/refs/tags/v0.1.35.tar.gz"
  sha256 "5097a2a30a00091d116ceef936e9c1759e49d0c23814d21947ddb50b0fbdbe72"
  license "Apache-2.0"
  head "https://github.com/mineiros-io/terramate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e0edbb16e6c4babc793f7dc65af3af5b69414088108cb0e99f533471a92f5504"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f68206f7b13b90a3c104659fb98bd22452ce29641a50aeeab52531c8406bd1c0"
    sha256 cellar: :any_skip_relocation, monterey:       "49a093a3708f321ab8e67f98118aa302bd6afad9be6c8e2b760de90346d7e733"
    sha256 cellar: :any_skip_relocation, big_sur:        "5b37ab91f5fe299c853b1523dc61b9b180a4fb81308b58415b22f932c9cafb36"
    sha256 cellar: :any_skip_relocation, catalina:       "d9e159b17279dd522fdd0509b2e22c56b13cbdeb5d8d72dc87e6c83d858bae91"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d16e0ee8ebe9dbaeac22e919b81982430472959ccfc51e0eed306d9bbb055794"
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
