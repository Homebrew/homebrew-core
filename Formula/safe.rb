class Safe < Formula
  desc "Command-line interface for Vault"
  homepage "https://github.com/starkandwayne/safe"
  url "https://github.com/starkandwayne/safe/archive/v1.0.2.tar.gz"
  sha256 "ab439378ac04f613986e6b3ffe883071179a82f578ba5947f9690e99b5ed4bfd"

  bottle do
    cellar :any_skip_relocation
    sha256 "cc0ba1efffe682de39f15d4564cacbd6150a21aea05829cc1d7758fdab07f004" => :mojave
    sha256 "5bfc8eb225573e39180516d1f252f1a5a695fb4c80da7bcbcedb0e112fa023ae" => :high_sierra
    sha256 "e2d03a5b45a8c59d5f4a7d75d739520dc2193e31d88e4bec5a7c2a27fa93bbb3" => :sierra
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
