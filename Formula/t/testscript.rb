class Testscript < Formula
  desc "Integration tests for command-line applications in .txtar format"
  homepage "https://github.com/rogpeppe/go-internal/tree/master/cmd/testscript"
  url "https://github.com/rogpeppe/go-internal/archive/refs/tags/v1.16.0.tar.gz"
  sha256 "78662c2e70976573ee61da4a050d1f10ca495ab35791b7be14d09badab28192f"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0dec97abfa956468bac1ba840642533eb47617e9b1a7f2f9b100ce4d26c56f34"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0dec97abfa956468bac1ba840642533eb47617e9b1a7f2f9b100ce4d26c56f34"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0dec97abfa956468bac1ba840642533eb47617e9b1a7f2f9b100ce4d26c56f34"
    sha256 cellar: :any_skip_relocation, sonoma:        "9bd77c074d5fec8bfb6b8cb0d652184fcc259d17e7ff027907b2d1eaddb434dd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4c441e0c534ba98c916f6472f135d4aed2f8cbb376d0d384955cacc0f76d3c77"
    sha256 cellar: :any,                 x86_64_linux:  "16d4e73d40915f403dff6b16fe6772ff5de580e70c1baea6811cdd54e1fb7f4e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/testscript"
  end

  test do
    (testpath/"hello.txtar").write("exec echo hello!\nstdout hello!")

    assert_equal "PASS\n", shell_output("#{bin}/testscript hello.txtar")
  end
end
