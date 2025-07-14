class Redress < Formula
  desc "Tool for analyzing stripped Go binaries compiled with the Go compiler"
  homepage "https://github.com/goretk/redress"
  url "https://github.com/goretk/redress/archive/refs/tags/v1.2.32.tar.gz"
  sha256 "752d2608b35c52e900de95dbd0531ee64132bcb50692095c5cc09a2d45bc0e4e"
  license "AGPL-3.0-only"
  head "https://github.com/goretk/redress.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "28ddc6ce90ff2d5bc45eb13135a188faf99927970250cbf39dd24fb91e8852b6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "28ddc6ce90ff2d5bc45eb13135a188faf99927970250cbf39dd24fb91e8852b6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "28ddc6ce90ff2d5bc45eb13135a188faf99927970250cbf39dd24fb91e8852b6"
    sha256 cellar: :any_skip_relocation, sonoma:        "a549214cba87045c37d95a82b3d17beb59e2abf84941da09fc83143f07e0985d"
    sha256 cellar: :any_skip_relocation, ventura:       "a549214cba87045c37d95a82b3d17beb59e2abf84941da09fc83143f07e0985d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cc1c9ba1191f3d9c2ff9eee807ba6281b781fb8d928151fbb36c7d910505f6d2"
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
