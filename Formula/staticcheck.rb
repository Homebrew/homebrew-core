class Staticcheck < Formula
  desc "State of the art linter for the Go programming language"
  homepage "https://staticcheck.io/"
  url "https://github.com/dominikh/go-tools/archive/2022.1.3.tar.gz"
  sha256 "b95691c8e7cfff90120249dbd827ee021f23031a498e201713d4dec23deb5974"
  license "MIT"
  head "https://github.com/dominikh/go-tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ffb6b84f677508c45f98376ad9ccfa82c3d865b5fd53bbf6f48de32d2bcbf03f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "796446395086877328615acec37c81a1edc4410c49f179516ac6260934a46638"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "67447db0bf46527f21fc2ac8b3a11c0628516c20d8ab7da5799993ec674ff23b"
    sha256 cellar: :any_skip_relocation, ventura:        "866762339353868d1c1f0fa091cac845639aa8412c0236ef1c179db5c6e6302a"
    sha256 cellar: :any_skip_relocation, monterey:       "303e35bb9bd4b378f7ed86cdb6d58c2b54cd16818ede6d9f5fbd8b4a2001a3a4"
    sha256 cellar: :any_skip_relocation, big_sur:        "e689ef99aebf15b523e668a507ae791352a0bdc608c672ef476a002ca3365305"
    sha256 cellar: :any_skip_relocation, catalina:       "1638b6f0c9fa5e3f7604ebe780118af69cdf6e0c658cf88e64ca162b25d375eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "015fea1a4798a30c0aff8b612f5f1ac00e8716504c43b4f6f05dc976c686a823"
  end

  depends_on "go"

  def install
    system "go", "build", *std_go_args, "./cmd/staticcheck"
  end

  test do
    (testpath/"test.go").write <<~EOS
      package main

      import "fmt"

      func main() {
        var x uint
        x = 1
        fmt.Println(x)
      }
    EOS
    json_output = JSON.parse(shell_output("#{bin}/staticcheck -f json test.go", 1))
    assert_equal json_output["code"], "S1021"
  end
end
