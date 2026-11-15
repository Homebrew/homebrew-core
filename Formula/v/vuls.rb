class Vuls < Formula
  desc "Agentless Vulnerability Scanner for Linux/FreeBSD"
  homepage "https://vuls.io/"
  license "GPL-3.0-only"
  head "https://github.com/future-architect/vuls.git", branch: "master"

  stable do
    url "https://github.com/future-architect/vuls/archive/refs/tags/v0.42.0.tar.gz"
    sha256 "361724c40b463825ef0106314353caacd49452156fffedf7dd415a888e83675e"

    # Update Trivy for Go 1.27.
    patch do
      url "https://github.com/future-architect/vuls/commit/b662910905c8f035216e036539fc1e46d2d68ab8.patch?full_index=1"
      sha256 "8dc0983100a08c29f582c33a1d7550c29951f042f68e3918b206ef53e8246b28"
      type :backport
      resolves "https://github.com/future-architect/vuls/pull/2674"
    end

    # Adapt to Trivy's updated go.mod parser.
    patch do
      url "https://github.com/future-architect/vuls/commit/e2097f2fd4df904250d5c0f4bb92a07e49080d48.patch?full_index=1"
      sha256 "354a7d21b5d9a9e204837ae09e2014e0bf0ea7f8f217dba3ec6d2e510ef9fb57"
      type :backport
      resolves "https://github.com/future-architect/vuls/pull/2674"
    end

    # Preserve the new Trivy database source in vulnerability results.
    patch do
      url "https://github.com/future-architect/vuls/commit/db525e867971465a56c89efca71390e9c249d96e.patch?full_index=1"
      sha256 "bcbc9598b6147670e2568555fcbd18c5f63fae08933614f2e0ae67615f0a3c54"
      type :backport
      resolves "https://github.com/future-architect/vuls/pull/2674"
    end

    # Keep JAR manifest parsing aligned with the updated Trivy dependency.
    patch do
      url "https://github.com/future-architect/vuls/commit/b1b1cbbf2b54a6ebda73a9864ce0479db8b6a622.patch?full_index=1"
      sha256 "47a369776e94d1e49f48b9979ee2657ff0f8274eeefc6bb5a792b83347ff3a9b"
      type :backport
      resolves "https://github.com/future-architect/vuls/pull/2674"
    end
  end

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
