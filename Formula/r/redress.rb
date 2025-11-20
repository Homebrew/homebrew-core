class Redress < Formula
  desc "Tool for analyzing stripped Go binaries compiled with the Go compiler"
  homepage "https://github.com/goretk/redress"
  url "https://github.com/goretk/redress/archive/refs/tags/v1.2.47.tar.gz"
  sha256 "44a6cf442e7d082523fc9eea70764e7a3b0529fa03d4bfdb8684a7e6187d1039"
  license "AGPL-3.0-only"
  head "https://github.com/goretk/redress.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c4da63685df6305a2452b18cb3b57b3b39f453546ceb36d4a8b7127c439f638e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "01a583b1b75e061251a3ddf2dd7b0e5727b9fafdacf67c316e45ced41e195cde"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8233cd67c287688d90162de5849ecf031219cebc10104cca145c94d0d1364f7d"
    sha256 cellar: :any_skip_relocation, sonoma:        "9bd8e8d7c030837f5b701c0373b39ec99f333e342e55edb8fd19784e04c80ec1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5550f32c8b80dd3165e00afbc63d42ab9e7774fbc3abbb18985554d0de0fea03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d457cf9c7b5b571d0bb83a6db61e8668d8b777996415f958b81410b9915bb720"
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

    test_bin_path = bin/"redress"
    output = shell_output("#{bin}/redress info '#{test_bin_path}'")
    assert_match "Build ID", output
  end
end
