class Safe < Formula
  desc "Command-line interface for Vault"
  homepage "https://github.com/starkandwayne/safe"
  url "https://github.com/starkandwayne/safe/archive/v0.9.8.tar.gz"
  sha256 "c02797d21782d48c41e926bc88c0273046806e14a483e115462dc0d471a6d022"

  bottle do
    cellar :any_skip_relocation
    sha256 "87f9ff12f2050e6cf81ea6f0718dab4cdcff165dbfc9c68e38ae795f3642deb6" => :mojave
    sha256 "840167416cbae1138531b15856b3b1c592f70beccdc21f0c400f25aae66ebecb" => :high_sierra
    sha256 "4c0f6ee002042d208f02ec2d31681710db275d30c5468186d02090c9ca272f82" => :sierra
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
