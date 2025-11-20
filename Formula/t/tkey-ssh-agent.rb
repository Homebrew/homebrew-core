class TkeySshAgent < Formula
  desc "SSH agent for use with the TKey security stick"
  homepage "https://tillitis.se/"
  url "https://github.com/tillitis/tkey-ssh-agent/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "abe43e1948101a5da007ff997161216ee7d44a54e3fa6b0aa255c22fcab11ae1"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "07136724f75aaf2969204ecbda818cd0b66308a2d088d21984f254313d2a8804"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4b6dc23d84a7f3a3b443b8adda359831d6d41105616bd06587dde36482a5ff51"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ad3c70f056b623588b70a516f7e09a9571c98a885b6e373b5191f03ae134a19c"
    sha256 cellar: :any_skip_relocation, sonoma:        "4cfb085857fead5f33b038fc74a07ee555af9f96cf445247c10fe663426e0cd2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "72b5bcdb56861eee3ea3c512141a041d171c14c6977195351fa5041b5d6dac57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e3dc65ac11001c1f6f963a3e9526f18565053e0a1fe674526a06cfac1beaa127"
  end

  depends_on "go" => :build

  on_macos do
    depends_on "pinentry-mac"
  end

  on_linux do
    depends_on "pinentry"
  end

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/tkey-ssh-agent"
    man1.install "system/tkey-ssh-agent.1"

    (var/"run").mkpath
    (var/"log").mkpath
  end

  def caveats
    <<~EOS
      To use this SSH agent, set this variable in your ~/.zshrc and/or ~/.bashrc:
        export SSH_AUTH_SOCK="#{var}/run/tkey-ssh-agent.sock"
    EOS
  end

  service do
    run macos: [
          opt_bin/"tkey-ssh-agent",
          "--agent-socket",
          var/"run/tkey-ssh-agent.sock",
          "--uss",
          "--pinentry",
          HOMEBREW_PREFIX/"bin/pinentry-mac",
        ],
        linux: [
          opt_bin/"tkey-ssh-agent",
          "--agent-socket",
          var/"run/tkey-ssh-agent.sock",
          "--uss",
        ]
    keep_alive true
    log_path var/"log/tkey-ssh-agent.log"
    error_log_path var/"log/tkey-ssh-agent.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tkey-ssh-agent --version")
    socket = testpath/"tkey-ssh-agent.sock"
    fork { exec bin/"tkey-ssh-agent", "--agent-socket", socket }
    sleep 1
    assert_path_exists socket
  end
end
