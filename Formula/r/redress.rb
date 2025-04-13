class Redress < Formula
  desc "Tool for analyzing stripped Go binaries compiled with the Go compiler"
  homepage "https://github.com/goretk/redress"
  url "https://github.com/goretk/redress/archive/refs/tags/v1.2.24.tar.gz"
  sha256 "f1dffd4b59fd88405b46883e3cc7f32818392ff1007037db4719b2c44d35aeef"
  license "AGPL-3.0-only"
  head "https://github.com/goretk/redress.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7e4dfaa0d98718041d1116caed79445a3af8471542c8798db95b0c865ad4622a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7e4dfaa0d98718041d1116caed79445a3af8471542c8798db95b0c865ad4622a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7e4dfaa0d98718041d1116caed79445a3af8471542c8798db95b0c865ad4622a"
    sha256 cellar: :any_skip_relocation, sonoma:        "e92045f84c46eabbd0be30211112281caa71803ca6b6e19b45d854f240fc22ba"
    sha256 cellar: :any_skip_relocation, ventura:       "e92045f84c46eabbd0be30211112281caa71803ca6b6e19b45d854f240fc22ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eb2b111080a98120f497a23628a87a69f3de34317558909865f2cc43c392f428"
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
