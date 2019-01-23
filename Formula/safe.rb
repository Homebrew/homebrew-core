class Safe < Formula
  desc "Command-line interface for Vault"
  homepage "https://github.com/starkandwayne/safe"
  url "https://github.com/starkandwayne/safe/archive/v1.0.0.tar.gz"
  sha256 "329bf2f35604ec1172d54eff4a5cb62d92979947397fa4c9d371fa75e0095726"

  bottle do
    cellar :any_skip_relocation
    sha256 "9a6cf3540b0440d85d32e39a66634334775844b8c50e1554cdd4c233edfb6501" => :mojave
    sha256 "36586e2ffde76d86670a966e16e5f9f2c289a79e9a803d04f9e9328dd348ea76" => :high_sierra
    sha256 "e47d7d0c62a3fe97a355eef45fb99082f220c47d3be80b3d889324ba51a31319" => :sierra
  end

  depends_on "go" => :build
  depends_on "vault"

  def install
    ENV["GOPATH"] = buildpath
    ENV["VERSION"] = version

    (buildpath/"src/github.com/starkandwayne/safe").install buildpath.children

    cd "src/github.com/starkandwayne/safe" do
      system "make", "build"
      bin.install "safe"
      prefix.install_metafiles
    end
  end

  test do
    require "yaml"

    pid = fork { exec "#{bin}/safe", "local", "--memory" }
    sleep 1
    handshake_yaml = Utils.popen_read("#{bin}/safe", "get", "secret/handshake")
    Process.kill("TERM", pid)

    parsed = YAML.safe_load(handshake_yaml)
    assert_equal "knock", parsed["knock"]
  end
end
