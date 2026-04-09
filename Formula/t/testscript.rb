class Testscript < Formula
  desc "Integration tests for command-line applications in .txtar format"
  homepage "https://github.com/rogpeppe/go-internal/tree/master/cmd/testscript"
  url "https://github.com/rogpeppe/go-internal/archive/refs/tags/v1.14.1.tar.gz"
  sha256 "7e54f6d0f002a4904f150e29417515b286ff3b0bbde8e1a01082cbb5178132cb"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "28d3ec9f59f45bbc4d9422e206e72a57e219d7f406f45358969047c0b2c7d2b0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "32cde373625b9755ac45543595073083f253574b0bfdf50ce6d42fd8e20f08b0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "32cde373625b9755ac45543595073083f253574b0bfdf50ce6d42fd8e20f08b0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "32cde373625b9755ac45543595073083f253574b0bfdf50ce6d42fd8e20f08b0"
    sha256 cellar: :any_skip_relocation, sonoma:        "49b838e6643cee284d00a50e1cd8be9c5b3d67033856bc360deef31f2c629fcc"
    sha256 cellar: :any_skip_relocation, ventura:       "49b838e6643cee284d00a50e1cd8be9c5b3d67033856bc360deef31f2c629fcc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c20bb5d4ba2e8032f66e5c61ddeaf01d07052db00e6810814be3abc85714f992"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "022c023408e7ecc0d604e44d262d675fb4be88303ea8794b422f1b472009e1ab"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/testscript"
  end

  test do
    (testpath/"hello.txtar").write("exec echo hello!\nstdout hello!")

    assert_equal "PASS\n", shell_output("#{bin}/testscript hello.txtar")
  end
end
