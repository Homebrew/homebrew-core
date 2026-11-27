class Sqlcmd < Formula
  desc "Microsoft SQL Server command-line interface"
  homepage "https://github.com/microsoft/go-sqlcmd"
  url "https://github.com/microsoft/go-sqlcmd/archive/refs/tags/v1.11.0.tar.gz"
  sha256 "0191aac329e749b4ccc2e94ae56b5d1fc27caf3269d37bb7e5114329ebd7211e"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    manifest_sha256 "a1b7ec39b73d7acb65aa569b745514927329896275a9a73c5be790595a6c5f0e"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e434bb4a9ab0786b0f2de35c5051914d214d4a527e2a91e681496c19fb4fd445"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b63c28e4f0d74cac5410af86396759964b210720d087dad2eab1bf17cb5011d4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "52360221838209c2c2ca00996447f45e6c00a6d775926ddd6d13286054902af6"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "82e6e2a758e8a811218c9287c464bff47be54cfd75a58f05579c7070578d29b2"
    sha256 cellar: :any,                 x86_64_linux:      "8ebde5d15bbb8b7d7e5393191112ef043cd51cb4e41da2745014f1afed5001c6"
  end

  depends_on "go" => :build

  # `test do` block expects `connection refused` from a local port
  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}"), "./cmd/modern"

    generate_completions_from_executable(bin/"sqlcmd", shell_parameter_format: :cobra)
  end

  test do
    out = shell_output("#{bin}/sqlcmd -S 127.0.0.1 -E -Q 'SELECT @@version'", 1)
    assert_match "connection refused", out

    assert_match version.to_s, shell_output("#{bin}/sqlcmd --version")
  end
end
