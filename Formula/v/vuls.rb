class Vuls < Formula
  desc "Agentless Vulnerability Scanner for Linux/FreeBSD"
  homepage "https://vuls.io/"
  url "https://github.com/future-architect/vuls/archive/refs/tags/v0.39.3.tar.gz"
  sha256 "c582817132f5fca07f93670a22e519ca91697c10dbc6dd9c049885292346acb1"
  license "GPL-3.0-only"
  head "https://github.com/future-architect/vuls.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "abbc69b663fe568e267887648b3ac4a2e869738f59c6b89f37adaf21537ebace"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "abbc69b663fe568e267887648b3ac4a2e869738f59c6b89f37adaf21537ebace"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "abbc69b663fe568e267887648b3ac4a2e869738f59c6b89f37adaf21537ebace"
    sha256 cellar: :any_skip_relocation, sonoma:        "fde52583cf487624a985987def323d168ab9281db671249ba05ee0e1d7ef6f26"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "60325c675b301abfbee56d587bd76948d7688fd97f078ecad9aaeb47f366cf66"
    sha256 cellar: :any,                 x86_64_linux:  "c2604386ec5c70cfabef3e908c4e0d8a4ab5a63d8922d6b5d01f00765927993a"
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
