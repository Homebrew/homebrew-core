class Redress < Formula
  desc "Tool for analyzing stripped Go binaries compiled with the Go compiler"
  homepage "https://github.com/goretk/redress"
  url "https://github.com/goretk/redress/archive/refs/tags/v1.2.25.tar.gz"
  sha256 "e3424971a2dead012e3fcac9e1fdb3fe8839c0e2682d1aca16796829e9072b30"
  license "AGPL-3.0-only"
  head "https://github.com/goretk/redress.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "af625dcfbe3a20923d754682cd3373d6d736834e9b732705d08664ec02f85e11"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "af625dcfbe3a20923d754682cd3373d6d736834e9b732705d08664ec02f85e11"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "af625dcfbe3a20923d754682cd3373d6d736834e9b732705d08664ec02f85e11"
    sha256 cellar: :any_skip_relocation, sonoma:        "38709076331e8920c09abd5b4bfa7e3bb0fc736150bd12db35c4593b92fedfdf"
    sha256 cellar: :any_skip_relocation, ventura:       "38709076331e8920c09abd5b4bfa7e3bb0fc736150bd12db35c4593b92fedfdf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "02e6cff1453b6cd93272d26552e771647b3eb821a2cb76d1628a0c3f5896a1a6"
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
