class Scalingo < Formula
  desc "CLI for working with Scalingo's PaaS"
  homepage "https://doc.scalingo.com/cli"
  url "https://github.com/Scalingo/cli/archive/refs/tags/1.22.0.tar.gz"
  sha256 "f08236d73195e9107f1a2d4aaf0d01bd40e852e8f032bc5d42227677f65ee4ec"
  license "BSD-4-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "076865c1e799cbca1130f970b94efdd346d09237cc391436ed4648b92b4ae237"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "da5dc9b77ca49a4550dea7734ed7606f956f558e98193ee2329743daacb7de21"
    sha256 cellar: :any_skip_relocation, monterey:       "5348d6cb5056a54cb3bd1dab86b5f69fbf25a125dbf350b32bf1b53db1272ac6"
    sha256 cellar: :any_skip_relocation, big_sur:        "fac6fe2ce3104c6390b25878ba100eeb93ba94e1760b59525338e3f382b17e95"
    sha256 cellar: :any_skip_relocation, catalina:       "b2825324d4f5edd479cd2b5476a8729d3da26bfec658394518417e300fabd302"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "982750a71bb0a4ade3c988bd9ed660aa35c73ee92699a00638095ccced4bda04"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "scalingo/main.go"
  end

  test do
    expected = <<~END
      +-------------------+-------+
      | CONFIGURATION KEY | VALUE |
      +-------------------+-------+
      | region            |       |
      +-------------------+-------+
    END
    config_output = shell_output("#{bin}/scalingo config")
    assert_equal config_output, expected
  end
end
