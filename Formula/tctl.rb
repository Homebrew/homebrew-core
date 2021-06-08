class Tctl < Formula
  desc "Temporal CLI (tctl)"
  homepage "https://temporal.io/"
  url "https://github.com/temporalio/temporal/archive/v1.10.1.tar.gz"
  sha256 "ce2effab4f757eb1940c6bdeebc1fc91f069fc453af02893c15a32d4a0701a2e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "132561b277b90e56b4a2f775d6b8bb95dfbc988afd06deee12503b752e1d70bf"
    sha256 cellar: :any_skip_relocation, big_sur:       "159e1c2cc023e841a49211c926cb1b0f8ebb8fc88fac429d02056f87daf1e551"
    sha256 cellar: :any_skip_relocation, catalina:      "106bf60c61faffa97feb3e20dbb716df903f5df70ae2089e4f7b7d5ad292f86d"
    sha256 cellar: :any_skip_relocation, mojave:        "34c047ad26d83a0e20bff93a4a6291e54fabf67ee9027fb91cc295e3337d62e5"
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
