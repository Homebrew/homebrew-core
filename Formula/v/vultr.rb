class Vultr < Formula
  desc "Command-line tool for Vultr services"
  homepage "https://github.com/vultr/vultr-cli"
  url "https://github.com/vultr/vultr-cli/archive/refs/tags/v3.8.0.tar.gz"
  sha256 "41cc0a9c62b61196802bc2105d0fd7c835eea554d8378eb84d6ce0c8c55eb16c"
  license "Apache-2.0"
  head "https://github.com/vultr/vultr-cli.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f9a74884d0432d2cc32306431969d37c16b64ed5ffa4f64834168cdf8595f808"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f9a74884d0432d2cc32306431969d37c16b64ed5ffa4f64834168cdf8595f808"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f9a74884d0432d2cc32306431969d37c16b64ed5ffa4f64834168cdf8595f808"
    sha256 cellar: :any_skip_relocation, sonoma:        "ae0b71e0b1b478419735a43ee0bafd839a3251316e2b560ae8239775ff06edd2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3beec54204eb258eb8770196ba08264f6f011cae6bc04818b96d5e7226cc4212"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a7c607a84ed880626d6a1feca8ced6fc1d13e9abcc5c6e5d50410c68bac81f07"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"vultr", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vultr version")
    assert_match "Custom", shell_output("#{bin}/vultr os list")
  end
end
