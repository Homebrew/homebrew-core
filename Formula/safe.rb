class Safe < Formula
  desc "Command-line interface for Vault"
  homepage "https://github.com/starkandwayne/safe"
  url "https://github.com/starkandwayne/safe/archive/v0.9.4.tar.gz"
  sha256 "40bfdf686b925824680ab336031f0679ac2da5674c9b76b2f3414f66b75d1dee"

  bottle do
    cellar :any_skip_relocation
    sha256 "48ff2727d9ec166e97d598967fcc22b001f2e228fe318f8dbcdf1aa7ec6df7ef" => :high_sierra
    sha256 "9a0876c8f6099a780259eeace5bce0974cb9bbc2494585bb2942f2b0e16d0100" => :sierra
    sha256 "9a83ea93a9681b1e538ca21920ae2e4afe3b020ab0ad71b5fd6408bd5c0dc9d4" => :el_capitan
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
