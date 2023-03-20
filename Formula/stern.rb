class Stern < Formula
  desc "Tail multiple Kubernetes pods & their containers"
  homepage "https://github.com/stern/stern"
  url "https://github.com/stern/stern/archive/v1.24.0.tar.gz"
  sha256 "4c75684974935bf90ce939b579c1cd67844e586a189a2a84e1a86165092d7919"
  license "Apache-2.0"
  head "https://github.com/stern/stern.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "35d8751469ade4a2e3e347f2c2601c16c3650af6793e83baa740338e45509dcf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7fe3c9495cbb7f82872828aa5fa24555b01baad230bd220d3a68af22b0d37320"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b76ef2a4b0f7753c06a2fd35420652c5788295f70cf68ce3f5e507817cd913d7"
    sha256 cellar: :any_skip_relocation, ventura:        "db0a2c505c0e054a5d7c643b3f8250fb2048891f74e2028733b05cb7b2de025c"
    sha256 cellar: :any_skip_relocation, monterey:       "77a2b2c6ebbea558ec3e708f23bfcd1d4b41d39933a8c3b4ecf1fcd37d36db68"
    sha256 cellar: :any_skip_relocation, big_sur:        "c7fca8edf983654c65640a52aa932a5518b4a352897ee1c7f3f51dbdd57f0c43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0c280eb0575a75a0c7435bd091eeab263f797fdb384c5fc743598cee66ed6c98"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/stern/stern/cmd.version=#{version}")

    # Install shell completion
    generate_completions_from_executable(bin/"stern", "--completion")
  end

  test do
    assert_match "version: #{version}", shell_output("#{bin}/stern --version")
  end
end
