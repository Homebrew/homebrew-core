class Redress < Formula
  desc "Tool for analyzing stripped Go binaries compiled with the Go compiler"
  homepage "https://github.com/goretk/redress"
  url "https://github.com/goretk/redress/archive/refs/tags/v1.2.85.tar.gz"
  sha256 "192e9163113189c10c2ad4eb80f26050452da3b7a304784cdd17e3d405ab0060"
  license "AGPL-3.0-only"
  head "https://github.com/goretk/redress.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f282f7c1c9d753e4e900c43717e622d81da427afa4cf8965aee27b7f573c3669"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b25736a8c54217d9387cb008f247f9ef8ffff150f32ebfda9abbdf5af7fe7dc8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "047fce16686bd7d4ceb04317af0d3c1b5c0fc44b9c9daed79b7ec459435ff1b3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "34c9b45ed7e8acadf68df48b39cb7791f4ea8c81d1c3f944f751fcd64e959c40"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "d3ab9e9a3c5cfe2242e4dd6fd6dc9f8972aac16c4758cb5554d18c2343c6a3bd"
    sha256 cellar: :any,                 x86_64_linux:      "d6bfcae685e9cf92b58eda0c2ed067f6712bc11414aa0f20c569000ef9039e28"
  end

  depends_on "go" => :build

  def install
    # https://github.com/goretk/redress/blob/develop/Makefile#L11-L14
    gore_version = File.read(buildpath/"go.mod").scan(%r{goretk/gore v(\S+)}).flatten.first

    ldflags = %W[
      -X main.redressVersion=#{version}
      -X main.goreVersion=#{gore_version}
      -X main.compilerVersion=#{Formula["go"].version}
    ]

    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"redress", shell_parameter_format: :cobra)
  end

  test do
    assert_match "Version:  #{version}", shell_output("#{bin}/redress version")

    test_bin_path = bin/"redress"
    output = shell_output("#{bin}/redress info '#{test_bin_path}'")
    assert_match "Build ID", output
  end
end
