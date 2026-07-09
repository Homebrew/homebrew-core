class YubikeyAgent < Formula
  desc "Seamless ssh-agent for YubiKeys and other PIV tokens"
  homepage "https://github.com/FiloSottile/yubikey-agent"
  url "https://github.com/FiloSottile/yubikey-agent/archive/refs/tags/v0.1.6.tar.gz"
  sha256 "f156d089376772a34d2995f8261d821369a96a248ab586d27e3be0d9b72d7426"
  license "BSD-3-Clause"
  head "https://github.com/FiloSottile/yubikey-agent.git", branch: "main"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "58e734ee1f173c8f04aa349617af6f29276a966ecaa6d0a9e0c0988994493f6b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9496f56ac8c4afd814f2edcadbaa15be410ea87b55b1b60876233b52bd28cdf6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "de350f79ac010b4b1e0ba8d8844fd1a44da4281076c1ab69612169b227e5f5a0"
    sha256 cellar: :any_skip_relocation, sonoma:        "2ba5fbcf44305440bec2b3d13c56b60003fd22bd44ed31369babf4b541de8e8e"
    sha256 cellar: :any,                 arm64_linux:   "f575668710835537bb2d24d6860360209e786ba6a2795fdad598627541bf58dd"
    sha256 cellar: :any,                 x86_64_linux:  "eb8a7a4740d2bdfccfd6499c5f1d935a71feea2451928c7735d7caf7d21f954b"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build

  uses_from_macos "pcsc-lite"

  on_linux do
    depends_on "pinentry"
  end

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=v#{version}")
    (var/"run").mkpath
  end

  def caveats
    <<~EOS
      To use this SSH agent, set this variable in your ~/.zshrc and/or ~/.bashrc:
        export SSH_AUTH_SOCK="#{var}/run/yubikey-agent.sock"
    EOS
  end

  service do
    run [opt_bin/"yubikey-agent", "-l", var/"run/yubikey-agent.sock"]
    keep_alive true
    log_path var/"log/yubikey-agent.log"
    error_log_path var/"log/yubikey-agent.log"
  end

  test do
    socket = testpath/"yubikey-agent.sock"
    spawn bin/"yubikey-agent", "-l", socket
    sleep 1
    assert_path_exists socket
  end
end
