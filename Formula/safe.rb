class Safe < Formula
  desc "Command-line interface for Vault"
  homepage "https://github.com/starkandwayne/safe"
  url "https://github.com/starkandwayne/safe/archive/v0.9.9.tar.gz"
  sha256 "bd13e711b384930249ba93a5df1269019d69ccbd5add832bd538cd7bb8e545f4"

  bottle do
    cellar :any_skip_relocation
    sha256 "12d909578b737de009be9c5613ef50c9e4282162a5fc46a1f63bffebbfdc621f" => :mojave
    sha256 "264ca7e9c4351e2c445d1baceeca6f0f8792990e845746c3a83ebe46a4e89d9d" => :high_sierra
    sha256 "1e75ecfa450f8f76b87af4ae8b77acf4ad4dfc8a4f5da10fd779083d918e6e30" => :sierra
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
