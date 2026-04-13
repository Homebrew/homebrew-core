class Redress < Formula
  desc "Tool for analyzing stripped Go binaries compiled with the Go compiler"
  homepage "https://github.com/goretk/redress"
  url "https://github.com/goretk/redress/archive/refs/tags/v1.2.64.tar.gz"
  sha256 "12623b9205b61e8cfa0f8115002182f9e0ceb9803d3b51a9e4f8eddd41ecb75c"
  license "AGPL-3.0-only"
  head "https://github.com/goretk/redress.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "de42c81406bd24f302f218df4f185885d1623daaa09305fcaa492b9217c4a449"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6124546bf9571366c28201c2c2a0b76234643081c75151ecbf9507c9cdced0b1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7f9f67ee2127d6be66b99942a3fa248a8610044d83e1bed4f4b50d0d7fabda1f"
    sha256 cellar: :any_skip_relocation, sonoma:        "aa93197429a019de14541fc9dbee4b867faf431adcd036345b92a28944e1dc43"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b59aca6c247e668e4306a3eb22bfcd98c5e4ee257530468a1779897308b50d1b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "44783a9e8930ceea51efc10329b46d583772db63cbe103d1e9506c1aefbddf56"
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
