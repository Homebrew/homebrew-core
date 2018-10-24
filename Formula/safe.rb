class Safe < Formula
  desc "Command-line interface for Vault"
  homepage "https://github.com/starkandwayne/safe"
  url "https://github.com/starkandwayne/safe/archive/v0.9.8.tar.gz"
  sha256 "c02797d21782d48c41e926bc88c0273046806e14a483e115462dc0d471a6d022"

  bottle do
    cellar :any_skip_relocation
    sha256 "b57ef80510129dd2b85449ed5ebe1cf9c2e17d5685fbf319541d7797b78353f3" => :mojave
    sha256 "f52376ec32aa15af052b0ba84728d1d083c568e05a8628d848a2f009699236d2" => :high_sierra
    sha256 "b31d864d829f4228797e27e0c9569d9d704e3be022cbc094a22076ed528afe0e" => :sierra
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
