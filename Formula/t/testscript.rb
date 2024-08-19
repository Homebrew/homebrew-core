class Testscript < Formula
  desc "Integration tests for command-line applications in .txtar format"
  homepage "https://github.com/rogpeppe/go-internal/tree/master/cmd/testscript"
  url "https://github.com/rogpeppe/go-internal/archive/refs/tags/v1.12.0.tar.gz"
  sha256 "b51d588d05f3e82d3045545ef46bd758a0610b9cfde1ae243489a593908b6060"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ff89d42aed19e76bde27a25603838030a9bd9b36f390ba77e2a2ec6606d31f6c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "48f0f71c046f7fd3b299a52e16102ad2d400611730a9ac8d3efa0c5213d75343"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f9f8e27f6a330bd5f2d96e2eec9027be814841cbc9987686870391f31ea4c178"
    sha256 cellar: :any_skip_relocation, sonoma:         "2e8751265b7ce2e4485f6efbb96f7183d5d2b659d58f140015b127ab36754033"
    sha256 cellar: :any_skip_relocation, ventura:        "e06976a430edc309215a9fb33ff78b0b8517b49bd47f196af297e606473aa7c2"
    sha256 cellar: :any_skip_relocation, monterey:       "2d1397abe5f677d8c04593f47a43158248a9078213f492cc7f648346fbec0372"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b52ddb065424f82aba7aa6105b38551ef0bf6b17fcd3a48845b79cec1ed6311a"
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
