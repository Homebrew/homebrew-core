class Redress < Formula
  desc "Tool for analyzing stripped Go binaries compiled with the Go compiler"
  homepage "https://github.com/goretk/redress"
  url "https://github.com/goretk/redress/archive/refs/tags/v1.2.19.tar.gz"
  sha256 "b7c4076b83f4c70cea241920b317069ae1b5cce6ce8169b6add2294f3efa6574"
  license "AGPL-3.0-only"
  head "https://github.com/goretk/redress.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a2151d39fbc6e6b2a920f2050569911a4d5127bc74295c069c43390631190a95"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a2151d39fbc6e6b2a920f2050569911a4d5127bc74295c069c43390631190a95"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a2151d39fbc6e6b2a920f2050569911a4d5127bc74295c069c43390631190a95"
    sha256 cellar: :any_skip_relocation, sonoma:        "9c3d88884a2d9f7e988a2e6ca4ba051376198d073b25c784f2e6b3d04d36b639"
    sha256 cellar: :any_skip_relocation, ventura:       "9c3d88884a2d9f7e988a2e6ca4ba051376198d073b25c784f2e6b3d04d36b639"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f9e189d0dea58df0fd2b888df74be89c980a1292fab941d1b51f61db2124f5e1"
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
