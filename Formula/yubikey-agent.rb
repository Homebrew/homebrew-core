class YubikeyAgent < Formula
  desc "Seamless ssh-agent for YubiKeys and other PIV tokens"
  homepage "https://filippo.io/yubikey-agent"
  url "https://github.com/FiloSottile/yubikey-agent/archive/v0.1.5.tar.gz"
  sha256 "724b21f05d3f822acd222ecc8a5d8ca64c82d5304013e088d2262795da81ca4f"
  license "BSD-3-Clause"
  head "https://github.com/FiloSottile/yubikey-agent.git", branch: "main"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f21dcc01bda26df3b7ba24520478c527cc0670f1da10f02eeff7e7a43dd1c9fa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "be5cb10b00b668117f846d909914b119313ba79f9d0a7170c81b471f775aeed9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d00bf8d22edfe56f5352e59ff3c72d91e98dcf64d4acc3d1c7a5edbadd61402d"
    sha256 cellar: :any_skip_relocation, ventura:        "aed889972c0513e793fb17d4750d0bba936463b9d710d142e6770f24ebf0e516"
    sha256 cellar: :any_skip_relocation, monterey:       "d5c58965efe5beed36e7927edd81cf15446015ddf05a6e35dda1ad7e7c1b8ade"
    sha256 cellar: :any_skip_relocation, big_sur:        "29df3472e1a5e57ed20f54cef3a5c4e87662e5c64f55338b01239741795447c3"
    sha256 cellar: :any_skip_relocation, catalina:       "4e7259eeb5ddd924251e7c73f6ae6904804193e4fee4d49e95fc02f211d3ac2e"
    sha256 cellar: :any_skip_relocation, mojave:         "bf031ee9b131fa3646b624bb6c84a0fc5b02f3abd6b693c5d5c488e58bb4e89c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cb43a6764a9caa2c39fba8bdd5ebe79c677923b004f8c2280213bb4afc298d17"
  end

  depends_on "go" => :build

  uses_from_macos "pcsc-lite"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "pinentry"
  end

  # Support go 1.17, remove when upstream patch is merged/released
  # https://github.com/FiloSottile/yubikey-agent/pull/99
  patch do
    url "https://github.com/FiloSottile/yubikey-agent/commit/92e45828da1c33531f507625f41e3bdadfe3ee86.patch?full_index=1"
    sha256 "605503152d3ea75072a98366994b65e4810c54e3dc690d8d47b9fb67ef47bd4d"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=v#{version}")
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
