class Vuls < Formula
  desc "Agentless Vulnerability Scanner for Linux/FreeBSD"
  homepage "https://vuls.io/"
  url "https://github.com/future-architect/vuls/archive/refs/tags/v0.39.2.tar.gz"
  sha256 "a1a76584b1e694458045e08a440e645f1c655b64c67f5a5cbf9f7bf8b3bd0c41"
  license "GPL-3.0-only"
  head "https://github.com/future-architect/vuls.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3c7cd1057e1453a84dd84990da5cb77edd8c1d0144abb9b03c27dd7b427ee550"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3c7cd1057e1453a84dd84990da5cb77edd8c1d0144abb9b03c27dd7b427ee550"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3c7cd1057e1453a84dd84990da5cb77edd8c1d0144abb9b03c27dd7b427ee550"
    sha256 cellar: :any_skip_relocation, sonoma:        "6bfe76acf54fe6e1daea1cb971b35b64f28747cbdcb9ea4ba2a59943ff412fb9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9f7146874c4f4d09d421b79403ef42034b0dd2f95207e3e9a9a95fdf6b8b6620"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8189544dd8634ce03fde70e79e46de5c0c8f7822f4eaaac0d37e8712ac5177cf"
  end

  depends_on "go" => :build

  def install
    ENV["GOEXPERIMENT"] = "jsonv2"

    ldflags = %W[
      -s -w
      -X github.com/future-architect/vuls/config.Version=#{version}
      -X github.com/future-architect/vuls/config.Revision=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags:, output: bin/"vuls"), "./cmd/vuls"
    system "go", "build", *std_go_args(ldflags:, output: bin/"vuls-scanner"), "./cmd/scanner"
    system "go", "build", *std_go_args(ldflags:, output: bin/"trivy-to-vuls"), "./contrib/trivy/cmd"
    system "go", "build", *std_go_args(ldflags:, output: bin/"future-vuls"), "./contrib/future-vuls/cmd"
    system "go", "build", *std_go_args(ldflags:, output: bin/"snmp2cpe"), "./contrib/snmp2cpe/cmd"
  end

  test do
    # https://vuls.io/docs/en/config.toml.html
    (testpath/"config.toml").write <<~TOML
      [default]
      logLevel = "info"

      [servers]
      [servers.127-0-0-1]
      host = "127.0.0.1"
    TOML

    %w[vuls vuls-scanner].each do |cmd|
      assert_match "Failed to configtest", shell_output("#{bin}/#{cmd} configtest 2>&1", 1)
    end

    %w[trivy-to-vuls future-vuls snmp2cpe].each do |cmd|
      assert_match version.to_s, shell_output("#{bin}/#{cmd} version")
    end
  end
end
