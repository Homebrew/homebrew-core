class Testscript < Formula
  desc "Integration tests for command-line applications in .txtar format"
  homepage "https://github.com/rogpeppe/go-internal/tree/master/cmd/testscript"
  url "https://github.com/rogpeppe/go-internal/archive/refs/tags/v1.13.1.tar.gz"
  sha256 "97914f4c73520fdc6740f9b5232e39e07cba569ae649eab537ee629a64288358"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d4cdcc70a5722dc60bdf040b4337f5cc85d0f687ad19c7de96776495b1ce57e0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d4cdcc70a5722dc60bdf040b4337f5cc85d0f687ad19c7de96776495b1ce57e0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d4cdcc70a5722dc60bdf040b4337f5cc85d0f687ad19c7de96776495b1ce57e0"
    sha256 cellar: :any_skip_relocation, sonoma:        "38c202aa10a22ae303d9b1adfd6da3f4e33641f922829417bec96d13e14030df"
    sha256 cellar: :any_skip_relocation, ventura:       "38c202aa10a22ae303d9b1adfd6da3f4e33641f922829417bec96d13e14030df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2c62263de0b1654e6a5645f86e509702aa30c7555415e36585d7dc49cd24311a"
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
