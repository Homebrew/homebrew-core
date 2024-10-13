class YubikeyAgent < Formula
  desc "Seamless ssh-agent for YubiKeys and other PIV tokens"
  homepage "https://filippo.io/yubikey-agent"
  url "https://github.com/FiloSottile/yubikey-agent/archive/refs/tags/v0.1.6.tar.gz"
  sha256 "f156d089376772a34d2995f8261d821369a96a248ab586d27e3be0d9b72d7426"
  license "BSD-3-Clause"
  head "https://github.com/FiloSottile/yubikey-agent.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "ce973f7cd1e1b5252f039e2fe2154bea75ce4b7439f49ec908774e57e6d15031"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "68bef9f91a8d57edc11813ae0261a1a7c18a9a37afd7b376cb29c5e0b836bd69"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "16fbb36f3bab79726c96cfc94dfda3aaabe290a8c72f5a73dba3d76cee916ee1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "028f45f8152045bbb98ddcac5ad41a554ee3a809e6e89cf76519b7b61e049243"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "408049a241d52174c985883c037422d9deac1596072a8aa6afdc59a1e4e8e437"
    sha256 cellar: :any_skip_relocation, sonoma:         "366ed6e74c186624edfb5fc808071b025c4e89d0b4d56dfea2fc3781b4daf865"
    sha256 cellar: :any_skip_relocation, ventura:        "9f4df13a79a921345e33da19009cd6a15c0371cfbec2a69875072ecc14ad116a"
    sha256 cellar: :any_skip_relocation, monterey:       "0908727c1be05e84776c37cbabdc38519882a1ddc9fe5faddfe60ecf9442bdc2"
    sha256 cellar: :any_skip_relocation, big_sur:        "16270ab84fc500f9ca17817fd35f783c5b272266e4abfaba79c8bc40e0a36cee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ee44c531db48e87a1f5fdd6f06159d37b4ae2877d80440ca3e437fdb4ec80e58"
  end

  depends_on "go" => :build

  uses_from_macos "pcsc-lite"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "pinentry"
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
