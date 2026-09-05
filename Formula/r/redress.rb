class Redress < Formula
  desc "Tool for analyzing stripped Go binaries compiled with the Go compiler"
  homepage "https://github.com/goretk/redress"
  url "https://github.com/goretk/redress/archive/refs/tags/v1.2.83.tar.gz"
  sha256 "e5bbc8730a1735ac241fda67eedf4fb070cc0192dc196e1ff0955e33f3b79f18"
  license "AGPL-3.0-only"
  head "https://github.com/goretk/redress.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5845c7d101f3178a9e465b5a0ed92a9bc27e43b87e3f08a47a52963586b032e2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d5ac74c4c65fb31ad1b1c0e1ab1fa52a242944de817b46aa936131f035eed064"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "06f1562113fbe19fc7a9bbb2decf045ddfe877889a7886db3545641c07bafdba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "77074db015b19a3045199422c2a9bad0caf9e855a0f36c9e926ce7a4d0da3115"
    sha256 cellar: :any,                 x86_64_linux:  "d0efa0e23ae8f9e64eaf3ec734ed4453e368323ac8d717dbc08a1764f507a027"
  end

  depends_on "go" => :build

  def install
    # https://github.com/goretk/redress/blob/develop/Makefile#L11-L14
    gore_version = File.read(buildpath/"go.mod").scan(%r{goretk/gore v(\S+)}).flatten.first

    ldflags = %W[
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
