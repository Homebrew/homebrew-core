class Swctl < Formula
  desc "Apache SkyWalking CLI (Command-line Interface)"
  homepage "https://skywalking.apache.org/"
  url "https://github.com/apache/skywalking-cli/archive/refs/tags/0.15.0.tar.gz"
  sha256 "2b167a3f32939a6fa03363720e94d5c44e2e66563a5991627b109a2377883c7d"
  license "Apache-2.0"
  head "https://github.com/apache/skywalking-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "39a3ce3fb1b08d2bfcdfb4e922239d9dd558b088233b58d6adb6c7474bcf49f4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "254f90510993dd04f46261ad3cc5286d143cbeac907cdd79ea2f5b7b1bc187c2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "95a0ad4824cc024500eb17a8427f69f79b4ea2f0a39ca79c35b9be4005572b60"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "1105428577f7c91e3780be2695f170f914e665450d5e5b40d836f5e39dc4d88c"
    sha256 cellar: :any,                 x86_64_linux:      "59e44d71c95374511cb6e8ae142a51f60c6d6f99b1a4ffa26159c6d5ce041569"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}"), "./cmd/swctl"

    generate_completions_from_executable(bin/"swctl", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/swctl --version 2>&1")

    output = shell_output("#{bin}/swctl --display yaml service ls 2>&1", 1)
    assert_match "level=fatal msg=\"Post \\\"http://127.0.0.1:12800/graphql\\\"", output
  end
end
