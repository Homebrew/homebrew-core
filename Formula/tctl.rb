class Tctl < Formula
  desc "Temporal CLI (tctl)"
  homepage "https://temporal.io/"
  url "https://github.com/temporalio/temporal/archive/v1.14.2.tar.gz"
  sha256 "bdb37931fa16867d9b3f5af50979369e9211b2bd95de42ed1d908531296edbaf"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8bf6567254510dbeac0fc9232773f021e6ff98c79c4ad7409de93e4174cd62ae"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7ce67563908014164540280d11b56026af616fbc8baacce2df6229bb2868729d"
    sha256 cellar: :any_skip_relocation, monterey:       "3781b7dfac05b45e8780b0f30795c2faff01980aefcfea2813db576d392cf437"
    sha256 cellar: :any_skip_relocation, big_sur:        "16a89d2d2262f31fcbd5d287a59f195282439146d572816801ce5029049c1dbe"
    sha256 cellar: :any_skip_relocation, catalina:       "c54082e3f44c786dd8ffd97d607950625aeeb1fdc58ecb369c46976541c85957"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "505b28158726e49d77411dc61955f90932a5fed6faf11bbd1d8858f4c6d2777b"
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
