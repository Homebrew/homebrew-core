class Redress < Formula
  desc "Tool for analyzing stripped Go binaries compiled with the Go compiler"
  homepage "https://github.com/goretk/redress"
  url "https://github.com/goretk/redress/archive/refs/tags/v1.2.51.tar.gz"
  sha256 "4dd69b637db3d3aafc63448930a6c87c297d1a1e43431b5e13a75e4bcb337f1b"
  license "AGPL-3.0-only"
  head "https://github.com/goretk/redress.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6fab3781dafd419abc31f80811845d39441eb2309fb24a89b5a87e6b7e42c265"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ac003dc0c78dcefc34134cc7be1069d5eff6a1f215e5b4eaaec183270f9940c3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "71d94dd0f4d21f0990f7fc81812419abe5e6a5a75bd2f9a0c3bb8de57e08e651"
    sha256 cellar: :any_skip_relocation, sonoma:        "ac76e3dca6649ee2de228bc547b200f64be0b91cc3e9eed3634ad6d1da82274b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "88a576b033e7f807adf26d38b7853d60362c01ae7d687424b0537b621c411923"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6ad959436988efb05d7a5610655fc04899213d28dda5700ab3f23e02b3c62d6c"
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
