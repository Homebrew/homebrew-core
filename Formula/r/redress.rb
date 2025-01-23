class Redress < Formula
  desc "Tool for analyzing stripped Go binaries compiled with the Go compiler"
  homepage "https://github.com/goretk/redress"
  url "https://github.com/goretk/redress/archive/refs/tags/v1.2.10.tar.gz"
  sha256 "6f761f66ddf32b2b749d596e88ef7dc11672ceb65542500ebd0ab2868a08b9b5"
  license "AGPL-3.0-only"
  head "https://github.com/goretk/redress.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8fc263fbb46987b316354f7e7592dd922ac08a2971c1c9f13034074dc001b43f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8fc263fbb46987b316354f7e7592dd922ac08a2971c1c9f13034074dc001b43f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8fc263fbb46987b316354f7e7592dd922ac08a2971c1c9f13034074dc001b43f"
    sha256 cellar: :any_skip_relocation, sonoma:        "2ef4cf50a12093b8994d0e4d4e1c3395d4a7dc810dda62e6f3932be9a9a0638c"
    sha256 cellar: :any_skip_relocation, ventura:       "2ef4cf50a12093b8994d0e4d4e1c3395d4a7dc810dda62e6f3932be9a9a0638c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "47d81618d0a9a78560cef661413eb93537f4b876070350d4fc18c0bb3f8ddd85"
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
