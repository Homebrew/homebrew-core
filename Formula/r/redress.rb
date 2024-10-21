class Redress < Formula
  desc "Tool for analyzing stripped Go binaries compiled with the Go compiler"
  homepage "https://github.com/goretk/redress"
  url "https://github.com/goretk/redress/archive/refs/tags/v1.2.3.tar.gz"
  sha256 "03d0af4a6b0d5f4461841930505f13d2d95dc2bac058cd882d7b561d82246c64"
  license "AGPL-3.0-only"
  head "https://github.com/goretk/redress.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ee6f09edf187d0c876c1f3b168cae77249a6d04d7425254176aefb92288ce2ce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ee6f09edf187d0c876c1f3b168cae77249a6d04d7425254176aefb92288ce2ce"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ee6f09edf187d0c876c1f3b168cae77249a6d04d7425254176aefb92288ce2ce"
    sha256 cellar: :any_skip_relocation, sonoma:        "e955d08564b3d8f09ff90c7e1351b8d6e056d5380a20e67ccf3949920cb3ad47"
    sha256 cellar: :any_skip_relocation, ventura:       "e955d08564b3d8f09ff90c7e1351b8d6e056d5380a20e67ccf3949920cb3ad47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d713eda494027d7b389f1f294da5a47c895cd7cc49a67037a8f1ea2eff8a7ee1"
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
