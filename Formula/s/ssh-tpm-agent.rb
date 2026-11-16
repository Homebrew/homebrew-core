class SshTpmAgent < Formula
  desc "SSH agent for Trusted Platform Module (TPM) key storage"
  homepage "https://github.com/Foxboron/ssh-tpm-agent"
  url "https://github.com/Foxboron/ssh-tpm-agent/releases/download/v0.9.0/ssh-tpm-agent-v0.9.0.tar.gz"
  sha256 "74682d750b3dfa97388d9334fd9f48b797c688642bec0f30d192bb5085c12577"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "da6db2dd2ad2cee583de59d02f4b3913871b7666ecc6c0e7e17e44a80575d6d0"
    sha256 cellar: :any,                 x86_64_linux: "e5f42eace6a0666da95b20ef5c3269d53b4369d5457da6bd51c292e1eedb393c"
  end

  depends_on "asciidoctor" => :build
  depends_on "go" => :build
  depends_on :linux
  depends_on "openssl@4"

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X main.Version=v#{version}"
    (buildpath/"cmd").each_child(false) do |cmd|
      next unless cmd.fnmatch?("ssh-tpm-*")

      system "go", "build", *std_go_args(ldflags:, output: bin/cmd), "./cmd/#{cmd}"
    end

    system "make", "man"
    man1.install Dir["man/*.1"]
  end

  test do
    assert_equal "/var/tmp/ssh-tpm-agent.sock", shell_output("#{bin}/ssh-tpm-agent --print-socket").strip
  end
end
