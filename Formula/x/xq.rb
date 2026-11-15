class Xq < Formula
  desc "Command-line XML and HTML beautifier and content extractor"
  homepage "https://github.com/sibprogrammer/xq"
  url "https://github.com/sibprogrammer/xq/archive/refs/tags/v1.5.1.tar.gz"
  sha256 "d57579a6c2009f3bd0f6b6f66f12744eb895575b767e7a02a099003c6bdcda3d"
  license "MIT"
  head "https://github.com/sibprogrammer/xq.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ddab1a3e2afd9fd8b9ea33bd1244b04f4892f3ffd4223cf98942ca6ee941e1a9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ddab1a3e2afd9fd8b9ea33bd1244b04f4892f3ffd4223cf98942ca6ee941e1a9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ddab1a3e2afd9fd8b9ea33bd1244b04f4892f3ffd4223cf98942ca6ee941e1a9"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "fe042f3ec87d8d1e08e9a0a38f6f4899a05e034a3810d2e24434939cc380e8b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "7d52f7273c52658a5048ee471d8194bf82db1abe201b111b22195beee744a1cc"
  end

  depends_on "go" => :build

  conflicts_with "python-yq", because: "both install `xq` binaries"

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = "0"
    system "go", "build", *std_go_args(ldflags: :goreleaser)
    man1.install "docs/xq.man" => "xq.1"
    generate_completions_from_executable(bin/"xq", shell_parameter_format: :cobra)
  end

  test do
    version_output = shell_output("#{bin}/xq --version 2>&1")
    assert_match "xq version #{version}", version_output

    run_output = pipe_output(bin/"xq", "<root></root>")
    assert_match("<root/>", run_output)
  end
end
