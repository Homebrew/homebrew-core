class Redress < Formula
  desc "Tool for analyzing stripped Go binaries compiled with the Go compiler"
  homepage "https://github.com/goretk/redress"
  url "https://github.com/goretk/redress/archive/refs/tags/v1.2.27.tar.gz"
  sha256 "3e0b953c75c8c48d924c867ff0a93e877ad653970cd65b7605e6c532cdc7d7e8"
  license "AGPL-3.0-only"
  head "https://github.com/goretk/redress.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c91b18de19dbf0e0c49aff4bb064bde0fd4d5095f80dcf235165923871152853"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c91b18de19dbf0e0c49aff4bb064bde0fd4d5095f80dcf235165923871152853"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c91b18de19dbf0e0c49aff4bb064bde0fd4d5095f80dcf235165923871152853"
    sha256 cellar: :any_skip_relocation, sonoma:        "c3921a3b1f3c42b92c3b59a1aee6fcc195021166b5e083708175c4d208788c20"
    sha256 cellar: :any_skip_relocation, ventura:       "c3921a3b1f3c42b92c3b59a1aee6fcc195021166b5e083708175c4d208788c20"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4e0abeb50c010290ea42ae4c0d87f02184e303fd8d21ca17e9deeef84fd0148a"
  end

  depends_on "go" => :build

  def install
    # https://github.com/goretk/redress/blob/develop/Makefile#L11-L14
    gore_version = File.read(buildpath/"go.mod").scan(%r{goretk/gore v(\S+)}).flatten.first

    ldflags = %W[
      -s -w
      -X main.redressVersion=#{version}
      -X main.goreVersion=#{gore_version}
      -X main.compilerVersion=#{Formula["go"].version}
    ]

    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"redress", "completion")
  end

  test do
    assert_match "Version:  #{version}", shell_output("#{bin}/redress version")

    test_module_root = "github.com/goretk/redress"
    test_bin_path = bin/"redress"

    output = shell_output("#{bin}/redress info '#{test_bin_path}'")
    assert_match(/Main root\s+#{Regexp.escape(test_module_root)}/, output)
  end
end
