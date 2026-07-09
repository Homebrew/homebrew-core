class Sqlcmd < Formula
  desc "Microsoft SQL Server command-line interface"
  homepage "https://github.com/microsoft/go-sqlcmd"
  url "https://github.com/microsoft/go-sqlcmd/archive/refs/tags/v1.10.0.tar.gz"
  sha256 "47fa2637d492c39ea75a0b41da4bbd127bf1891116f04861a96fba8bc5e654b6"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "959848a88dde30763e76eb3faeaece54c0e2a64e246cc155b3009a796ed89273"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "959848a88dde30763e76eb3faeaece54c0e2a64e246cc155b3009a796ed89273"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "959848a88dde30763e76eb3faeaece54c0e2a64e246cc155b3009a796ed89273"
    sha256 cellar: :any_skip_relocation, sonoma:        "c5c7baf6157a01057ca91de07b6c8b173a491abfe02f4b3f4c9a86ed3faa0ab1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d7ff9e052a8c4788fb01b534c0da578ea99851e1c819e5e540e5efb11ac44dd2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "80e19390b4e98dd9356b8f7cfd735709da60a1cf7f685c9560dd38602ed00a16"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/modern"

    generate_completions_from_executable(bin/"sqlcmd", shell_parameter_format: :cobra)
  end

  test do
    out = shell_output("#{bin}/sqlcmd -S 127.0.0.1 -E -Q 'SELECT @@version'", 1)
    assert_match "connection refused", out

    assert_match version.to_s, shell_output("#{bin}/sqlcmd --version")
  end
end
