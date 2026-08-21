class Vuls < Formula
  desc "Agentless Vulnerability Scanner for Linux/FreeBSD"
  homepage "https://vuls.io/"
  url "https://github.com/future-architect/vuls/archive/refs/tags/v0.40.1.tar.gz"
  sha256 "d2ff0468632b582aab434ee051c057c44fb0878ad9a7ad3ed980b6d4f2940de0"
  license "GPL-3.0-only"
  head "https://github.com/future-architect/vuls.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "288b2fdd583b429604539a0a0fe54e460a1e388ee8895eec329994853ca6ec7a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "288b2fdd583b429604539a0a0fe54e460a1e388ee8895eec329994853ca6ec7a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "288b2fdd583b429604539a0a0fe54e460a1e388ee8895eec329994853ca6ec7a"
    sha256 cellar: :any_skip_relocation, sonoma:        "65b3d1fdddc4a2156c9f549ff0a85c623cc1c63d2672ba9393b2c8ce2d81144b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "15075240cce58136758fdfc9682c696b84626d4f4902d98a3679fff7e6a55352"
    sha256 cellar: :any,                 x86_64_linux:  "bfc81776e8cbaf72f3b5035e44947d66469b11b1f1b68467165c6b00fba52aa9"
  end

  depends_on "go" => :build

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
