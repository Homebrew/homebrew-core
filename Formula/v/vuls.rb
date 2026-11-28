class Vuls < Formula
  desc "Agentless Vulnerability Scanner for Linux/FreeBSD"
  homepage "https://vuls.io/"
  url "https://github.com/future-architect/vuls/archive/refs/tags/v0.43.0.tar.gz"
  sha256 "966ec35edde6c2b854013af2fc861c144e29460632a2b94718ade642e803c0bf"
  license "GPL-3.0-only"
  head "https://github.com/future-architect/vuls.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    manifest_sha256 "11304db2230e7cf3c2c3fb8aa4fe764f3e873cdcc4aa0a293186e17f1af5389c"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "09e7834ab3ae9d0fa80652eacc6b97765ab50570f5ffae9d501d6ca3ddf7ecff"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "09e7834ab3ae9d0fa80652eacc6b97765ab50570f5ffae9d501d6ca3ddf7ecff"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "09e7834ab3ae9d0fa80652eacc6b97765ab50570f5ffae9d501d6ca3ddf7ecff"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "3a7651cfb5fcb75d89eb8e281f8e45f4d3ac6da4ee08d19570b8731dfc115324"
    sha256 cellar: :any,                 x86_64_linux:      "a378f0f645c3ec7f9cc2f7a02800c31dbddb56bddc407f3f7bebe726ef1135d1"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
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
