class Vultr < Formula
  desc "Command-line tool for Vultr services"
  homepage "https://github.com/vultr/vultr-cli"
  url "https://github.com/vultr/vultr-cli/archive/refs/tags/v3.8.0.tar.gz"
  sha256 "41cc0a9c62b61196802bc2105d0fd7c835eea554d8378eb84d6ce0c8c55eb16c"
  license "Apache-2.0"
  head "https://github.com/vultr/vultr-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "879612d01a2224cfdeeaddd7d8afa85ce071742e8af0deabe8afd9bcd851e71c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "879612d01a2224cfdeeaddd7d8afa85ce071742e8af0deabe8afd9bcd851e71c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "879612d01a2224cfdeeaddd7d8afa85ce071742e8af0deabe8afd9bcd851e71c"
    sha256 cellar: :any_skip_relocation, sonoma:        "7ff5eb9f6fde77ef29c3e113e1dcda6c0142c41b730a0163028ecf6faaf4bd75"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d91debae77ec8d0930597124fdfa1614736f797a88ae1e1df032a2121bee49c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "26d0f20f4eab68a6dd7c023ff3cabd474ac26d25422f98614611c5277ed825f8"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"vultr", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vultr version")
    assert_match "Custom", shell_output("#{bin}/vultr os list")
  end
end
