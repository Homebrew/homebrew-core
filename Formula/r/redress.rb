class Redress < Formula
  desc "Tool for analyzing stripped Go binaries compiled with the Go compiler"
  homepage "https://github.com/goretk/redress"
  url "https://github.com/goretk/redress/archive/refs/tags/v1.2.78.tar.gz"
  sha256 "571db7fe31b76706cfa6219e42a100a31bb35a28890fff419c70b44cffd5e7f2"
  license "AGPL-3.0-only"
  head "https://github.com/goretk/redress.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e6121456fd6aad6e4156f79c9cdc40b0c6b364e4dd734e2e7d6e7f78c6f7a1fc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "328c1de71bc743e2c05730932fdf9ed7e037f758c3ea992404d60a99693fc8d6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "075de0f0ec870042efded2060e1fcce700ebf0df13238630bf9a71892c38f123"
    sha256 cellar: :any_skip_relocation, sonoma:        "f4dcbc8e6bcf5ad62c33a0767a460c5d32252deacd0215fdf09bdb1347a19ec4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b280e0d2c83f5d15fd3131dce6316989cadcab476618158bb749d84df2065cf1"
    sha256 cellar: :any,                 x86_64_linux:  "23f96ea64f63698d507625dca53580d7583b8fe3c9a2dc45960c5f75004faeaa"
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
