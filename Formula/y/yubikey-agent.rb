class YubikeyAgent < Formula
  desc "Seamless ssh-agent for YubiKeys and other PIV tokens"
  homepage "https://github.com/FiloSottile/yubikey-agent"
  url "https://github.com/FiloSottile/yubikey-agent/archive/refs/tags/v0.1.6.tar.gz"
  sha256 "f156d089376772a34d2995f8261d821369a96a248ab586d27e3be0d9b72d7426"
  license "BSD-3-Clause"
  head "https://github.com/FiloSottile/yubikey-agent.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "13a582964b590f21b2fdd7c29ae6f76c2d598fc9a9e50e3f7e0086f6bb50fda1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bae16f841b3847ab59cbc42ef0a9c8944100b4817f0d20b7c0eb8c721a38dfe4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d18f07e88226c171546f67e9d598a6a91f0b2f6749c7359ff6d0b94951bb37ae"
    sha256 cellar: :any_skip_relocation, sonoma:        "554a94f134c4d2440a678a7a99d3cab10fa1956d1f07d9f3165572d907c6a6ea"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5151c4f4e1453cc1caca9fe4dd45361a6ffd88a0e5eb6005c248d5d8f1ae97a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "950ac75f5a78e63b0f9797db9f239f80269c785ad5bef591d470521bd7eddc28"
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
    spawn bin/"yubikey-agent", "-l", socket
    sleep 1
    assert_path_exists socket
  end
end
