class Vuls < Formula
  desc "Agentless Vulnerability Scanner for Linux/FreeBSD"
  homepage "https://vuls.io/"
  url "https://github.com/future-architect/vuls/archive/refs/tags/v0.38.6.tar.gz"
  sha256 "8284f666687723eadcea823aae61cd6759e857e6114b9811ae669367e0aeea7e"
  license "GPL-3.0-only"
  head "https://github.com/future-architect/vuls.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f279db38fad31c0bdf62890c3f059ca43723fa8ca3c32e84ce3733cd112610da"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1c679cabcd0f2d4f31dbc7c37c1d206edda0f9c0db3f6cc080ad5f31a5ea2bd2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "14367f1fca8ab7617d12d8bb587bf7bec5238a2ae46d0d2b9959d18e1a4a6acc"
    sha256 cellar: :any_skip_relocation, sonoma:        "e3b370b0eb38c8dc905d8c149619afc363f5be7c0a48083af1f83abf7f5bca51"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "36bb06b3fa589c0d4d5a8acffbd0e2366f5cce360aec9b91f2de1c5e81d13bf3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fd5c00776abb525dd78dc807543fb819d50534d72a17ed791492b757d2c079ee"
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
