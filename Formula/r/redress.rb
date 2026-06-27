class Redress < Formula
  desc "Tool for analyzing stripped Go binaries compiled with the Go compiler"
  homepage "https://github.com/goretk/redress"
  url "https://github.com/goretk/redress/archive/refs/tags/v1.2.77.tar.gz"
  sha256 "1d251518d49345693127ae97f7eb9eae202bfdb2cf467584ed2513c39b805237"
  license "AGPL-3.0-only"
  head "https://github.com/goretk/redress.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "25b68c732869564226d59422bc9b204b1be5102526517ab2cbe2a073fbe33708"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9cdd17caa4eb0614cadc070622f2a5bbd72d505ca91192dc27034ee0a789b82a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a118679001c29a8232bb0f39a3e9f15c36376101b928fa8f410f1b25084539c2"
    sha256 cellar: :any_skip_relocation, sonoma:        "bd2f18217cd752e874c9a9dc17cb36b82ea88bca5e19f6fedb09a9a8baad7d5d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c6205c8ee212f69ed0f2a2a18e411010611b94265672bac22f1781871f3dce1d"
    sha256 cellar: :any,                 x86_64_linux:  "a47f035a04220638ffa818e481dc0a3c840309350e4eb91dfbc7df66d6915439"
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

    generate_completions_from_executable(bin/"redress", shell_parameter_format: :cobra)
  end

  test do
    assert_match "Version:  #{version}", shell_output("#{bin}/redress version")

    test_bin_path = bin/"redress"
    output = shell_output("#{bin}/redress info '#{test_bin_path}'")
    assert_match "Build ID", output
  end
end
