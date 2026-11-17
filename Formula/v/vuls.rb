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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9fe64a0a8090d7222aafc9e43d5ac79c84ca65ba124a68dccd99845a5a7fe6f3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9fe64a0a8090d7222aafc9e43d5ac79c84ca65ba124a68dccd99845a5a7fe6f3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9fe64a0a8090d7222aafc9e43d5ac79c84ca65ba124a68dccd99845a5a7fe6f3"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "49c4d06b1284b727bc181c6833bc0bdeda2c95cc6787147f346125b01a8e636a"
    sha256 cellar: :any,                 x86_64_linux:      "8439db1898e190532c0a776f38ea8d727b5515ff1ab5e70fb4cbef67798da357"
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
