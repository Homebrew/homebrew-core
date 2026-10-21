class Vuls < Formula
  desc "Agentless Vulnerability Scanner for Linux/FreeBSD"
  homepage "https://vuls.io/"
  url "https://github.com/future-architect/vuls/archive/refs/tags/v0.42.0.tar.gz"
  sha256 "361724c40b463825ef0106314353caacd49452156fffedf7dd415a888e83675e"
  license "GPL-3.0-only"
  head "https://github.com/future-architect/vuls.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8cdb0c92768156f2365cc74373c032d04ba8c474255824a47af307f82cdb92e0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8cdb0c92768156f2365cc74373c032d04ba8c474255824a47af307f82cdb92e0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8cdb0c92768156f2365cc74373c032d04ba8c474255824a47af307f82cdb92e0"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ba59c86ddf2bb4f24499b965616820dd7f8eeea8a91da20e117c2043f7677086"
    sha256 cellar: :any,                 x86_64_linux:      "702cd0d4ba3cd62cc69b8300e68e3d6e222f2f68ad957a02f2ef3977a7f848ec"
  end

  # TODO: unpin go@1.26 when vuls (and trivy) support go 1.27
  # ref: https://github.com/aquasecurity/trivy/pull/11127
  depends_on "go@1.26" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["GOEXPERIMENT"] = "jsonv2"

    ldflags = %W[
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
