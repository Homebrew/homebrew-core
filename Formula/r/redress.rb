class Redress < Formula
  desc "Tool for analyzing stripped Go binaries compiled with the Go compiler"
  homepage "https://github.com/goretk/redress"
  url "https://github.com/goretk/redress/archive/refs/tags/v1.2.40.tar.gz"
  sha256 "dda2d634b463369e942d675513c3d9e7d18a707214b72175d7d2dd2d73e5a237"
  license "AGPL-3.0-only"
  head "https://github.com/goretk/redress.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e5e0d2a6a1f14a150d60c023d851546d8d0e0a67c3ef8755bbc06dd06f251599"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e5e0d2a6a1f14a150d60c023d851546d8d0e0a67c3ef8755bbc06dd06f251599"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e5e0d2a6a1f14a150d60c023d851546d8d0e0a67c3ef8755bbc06dd06f251599"
    sha256 cellar: :any_skip_relocation, sonoma:        "83e5dd724f1c6c2798356117f2c4e303cd1d99a400cc21fe4659b6b5cfd30157"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1817178b93fce77bf7b01c7b429c642eee0cbee2de63c224a626a24f0eac512e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "faec88a6be95a6b664ae571739402a64b2366fba549274418e64b63b907c0148"
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
