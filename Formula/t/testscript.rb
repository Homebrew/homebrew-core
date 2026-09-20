class Testscript < Formula
  desc "Integration tests for command-line applications in .txtar format"
  homepage "https://github.com/rogpeppe/go-internal/tree/master/cmd/testscript"
  url "https://github.com/rogpeppe/go-internal/archive/refs/tags/v1.16.0.tar.gz"
  sha256 "78662c2e70976573ee61da4a050d1f10ca495ab35791b7be14d09badab28192f"
  license "BSD-3-Clause"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4faebcc25d106ec84af5b62394f28b03c6ef7b5fa0942ea082473f2ea7c441b4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4faebcc25d106ec84af5b62394f28b03c6ef7b5fa0942ea082473f2ea7c441b4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4faebcc25d106ec84af5b62394f28b03c6ef7b5fa0942ea082473f2ea7c441b4"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e3be776edb189abaf720971f0a44db340c42cf5a8dc42281b75580f0119d6153"
    sha256 cellar: :any,                 x86_64_linux:      "10f7201419e8aee4ea028b91fa694bd48702427cd1352a9395cde7036805f6dc"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args, "./cmd/testscript"
  end

  test do
    (testpath/"hello.txtar").write("exec echo hello!\nstdout hello!")

    assert_equal "PASS\n", shell_output("#{bin}/testscript hello.txtar")
  end
end
