class Safe < Formula
  desc "Command-line interface for Vault"
  homepage "https://github.com/starkandwayne/safe"
  url "https://github.com/starkandwayne/safe/archive/v0.9.4.tar.gz"
  sha256 "40bfdf686b925824680ab336031f0679ac2da5674c9b76b2f3414f66b75d1dee"

  bottle do
    cellar :any_skip_relocation
    sha256 "e1d24c5e4fff23b059b01d2db0d0751990746f7d6bf059ebdd6addf6c094136b" => :mojave
    sha256 "0ea87154eb0e27459437405ffc69f0808cba26260d90b058578e4a4560e1b4d6" => :high_sierra
    sha256 "2c8f4aa792bebf2b3d2fb7640c434b0753c31f5a135ad7171f9cea3f90df6991" => :sierra
    sha256 "5dc57faafb0a65cf222223edf2d3dc3cc4cc21fe022863934c1fe984d7eef794" => :el_capitan
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
