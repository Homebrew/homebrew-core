class YubikeyAgent < Formula
  desc "Seamless ssh-agent for YubiKeys and other PIV tokens"
  homepage "https://filippo.io/yubikey-agent"
  url "https://github.com/FiloSottile/yubikey-agent/archive/v0.1.5.tar.gz"
  sha256 "724b21f05d3f822acd222ecc8a5d8ca64c82d5304013e088d2262795da81ca4f"
  license "BSD-3-Clause"
  head "https://filippo.io/yubikey-agent", using: :git

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "7d81c0d8715b152af95a5a9c2dbac4e36dff67ccb239762ce0652bf62c42b6e2"
    sha256 cellar: :any_skip_relocation, big_sur:       "72e53fa5e93d5f872e0d462ea4f4195f34adf14782f74db0a718dbfb5059fbbc"
    sha256 cellar: :any_skip_relocation, catalina:      "4e2c60b1ec376696a2a358b8fb21015007eeb35685b809a5053b529b62f3d31e"
    sha256 cellar: :any_skip_relocation, mojave:        "af1777f69a0237dce8afcc0b0c7b729074636171fa8532fa991ced0239555b2f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "431476cdf6aae6dfd45626977c0e0b2cc1ce35e9364ed068e7ba2a196ce3e442"
  end

  depends_on "go" => :build

  uses_from_macos "pcsc-lite"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "pinentry"
  end

  def install
    system "go", "build", *std_go_args, "-ldflags", "-X main.Version=v#{version}"
  end

  def post_install
    (var/"run").mkpath
    (var/"log").mkpath
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
    fork { exec bin/"yubikey-agent", "-l", socket }
    sleep 1
    assert_predicate socket, :exist?
  end
end
