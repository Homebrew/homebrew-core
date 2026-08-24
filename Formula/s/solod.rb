class Solod < Formula
  desc "Strict subset of Go with transpiler that translates to regular C"
  homepage "https://solod.dev/"
  url "https://github.com/solod-dev/solod.git",
    tag:      "v0.3.0",
    revision: "b4a71c0a7ec37a1657938f262ad8fa9bf55b46d4"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/solod-dev/solod.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7b32720c772895a003e2b73ea04f47bc67f0753c44b2beafb4408b7681867e7f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7b32720c772895a003e2b73ea04f47bc67f0753c44b2beafb4408b7681867e7f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7b32720c772895a003e2b73ea04f47bc67f0753c44b2beafb4408b7681867e7f"
    sha256 cellar: :any_skip_relocation, sonoma:        "5d42c324b3a249d2d742752d378bc5bdffcd37c9f296031d7a23589baf46ea6a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "08b18daec1bce0168125c420665bd5ae025fd611dcaa6178e1e9308d2572dd4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8ae6aba1fa8a2b55d392f1ffddec68fb632dc57becb0d18278fb006fa95bd4ae"
  end

  depends_on "go" => [:build, :test]

  conflicts_with "so", because: "both install `so` binaries"

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
