class Vuls < Formula
  desc "Agentless Vulnerability Scanner for Linux/FreeBSD"
  homepage "https://vuls.io/"
  url "https://github.com/future-architect/vuls/archive/refs/tags/v0.39.0.tar.gz"
  sha256 "11302e96c3d960bbdf70b2d025ca73cb50f9ff6b37945083c8f9e2cb165ab163"
  license "GPL-3.0-only"
  head "https://github.com/future-architect/vuls.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "55e5da3ab3ee8f0c10b7ccec5fdf4b3a2259bf84820701ec2d9d4d0aee2ce8b0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "55e5da3ab3ee8f0c10b7ccec5fdf4b3a2259bf84820701ec2d9d4d0aee2ce8b0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "55e5da3ab3ee8f0c10b7ccec5fdf4b3a2259bf84820701ec2d9d4d0aee2ce8b0"
    sha256 cellar: :any_skip_relocation, sonoma:        "4267e72ee940b09cc3c300e5cba603cdbc0f0c546665099d5d4ce3d78ad02e58"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "28f25367cb5140ebd2241dff756d3b1238ae8b112353fb628d0c8e7986558bdc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "78e751b7128bcadb95f3c24e1de071c6beab38beb0fd48c793e64aa78156ab9b"
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
