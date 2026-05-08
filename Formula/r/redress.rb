class Redress < Formula
  desc "Tool for analyzing stripped Go binaries compiled with the Go compiler"
  homepage "https://github.com/goretk/redress"
  url "https://github.com/goretk/redress/archive/refs/tags/v1.2.66.tar.gz"
  sha256 "29c3be55f3f74a5138615e19baecb1104a8a03d78079fbc0ae9c53ae02480bb3"
  license "AGPL-3.0-only"
  head "https://github.com/goretk/redress.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fc64a6b666b5a8e681432c0fe4a302da0ff702c19589c545a24c74b5292a1b28"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "95b521e84ae594402c6bd075e0122bf922ffdb4167617082fdabef013f15f957"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fb0dc7d22128605bc279a6d6bfc447d259a22917aa572f83c4610f6bb9b029a3"
    sha256 cellar: :any_skip_relocation, sonoma:        "5fc9f09dd03e9270afebd89c470de8f870e1174fc165bb10cdaab0e17ea03d7a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "29095b425633a461859e2d08cda46c08db1225e98f1783a71135dcbb7e633a8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "91320def415c7d0428311246fe890abd627156d9c0e60ede5d3a98eb16c71aba"
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
