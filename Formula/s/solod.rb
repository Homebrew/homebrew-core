class Solod < Formula
  desc "Strict subset of Go with transpiler that translates to regular C"
  homepage "https://solod.dev/"
  url "https://github.com/solod-dev/solod.git",
    tag:      "v0.4.0",
    revision: "e84cd34481f735ed30d03ef69eedd5c371c21532"
  license "BSD-3-Clause"
  head "https://github.com/solod-dev/solod.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "52e0ce878d48b04c96385c2fc407ddd90589861dddb427b742e2096fef94bd62"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "52e0ce878d48b04c96385c2fc407ddd90589861dddb427b742e2096fef94bd62"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "52e0ce878d48b04c96385c2fc407ddd90589861dddb427b742e2096fef94bd62"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "d920c0c42343a4e7d30e7c05e58b26055e7e544717c38df5f1dbc65b29049edf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "f23aa087960d006d27ac03224d95af7efab59966228707a32a8fb551e8e6c0d9"
  end

  depends_on "go" => [:build, :test]

  conflicts_with "so", because: "both install `so` binaries"

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(output: bin/"so"), "./cmd/so"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/so version")

    (testpath/"main.go").write <<~GO
      package main

      func main() {
      	println("Hello, World!")
      }
    GO

    system "go", "mod", "init", "testproject"

    assert_match "Hello, World!", shell_output("#{bin}/so run .")

    system bin/"so", "translate", "."
    assert_path_exists testpath/"main.c"
    assert_match "int main(void)", (testpath/"main.c").read
    assert_match "\"Hello, World!\"", (testpath/"main.c").read

    system ENV.cc, "-o", "main", "main.c", "so/builtin/builtin.c"
    assert_match "Hello, World!", shell_output("./main")
  end
end
