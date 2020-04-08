# Please don't update this formula until the release is official via
# mailing list or blog post. There's a history of GitHub tags moving around.
# https://github.com/hashicorp/vault/issues/1051
class Vault < Formula
  desc "Secures, stores, and tightly controls access to secrets"
  homepage "https://vaultproject.io/"
  url "https://github.com/hashicorp/vault.git",
      :tag      => "v1.4.0",
      :revision => "d808ace758b9bac5c84a9634ffbfae43c5f5a3ad"
  head "https://github.com/hashicorp/vault.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "38d5259e448cfc9ed592c80e55c062f9472cb672f30e87b3e7915a0b014ea52e" => :catalina
    sha256 "541f6e33d95ba47c199408052038cccaba9b5e3cdf43fb2b23e84645febd382e" => :mojave
    sha256 "550fda7af152696f0f8c7e1bbd228b7aa7802e6d9cb6f3a61e1fcbbc65462216" => :high_sierra
  end

  depends_on "go@1.13" => :build
  depends_on "gox" => :build

  def install
    ENV["GOPATH"] = buildpath

    # GOPRIVATE should be removed when v1.4.1 is released.
    #
    # https://github.com/macports/macports-ports/pull/6818
    # https://github.com/hashicorp/vault/issues/8696
    ENV["GOPRIVATE"] = "github.com/hashicorp/vault-plugin*"

    contents = buildpath.children - [buildpath/".brew_home"]
    (buildpath/"src/github.com/hashicorp/vault").install contents

    (buildpath/"bin").mkpath

    cd "src/github.com/hashicorp/vault" do
      system "make", "dev"
      bin.install "bin/vault"
      prefix.install_metafiles
    end
  end

  plist_options :manual => "vault server -dev"

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
        <dict>
          <key>KeepAlive</key>
          <dict>
            <key>SuccessfulExit</key>
            <false/>
          </dict>
          <key>Label</key>
          <string>#{plist_name}</string>
          <key>ProgramArguments</key>
          <array>
            <string>#{opt_bin}/vault</string>
            <string>server</string>
            <string>-dev</string>
          </array>
          <key>RunAtLoad</key>
          <true/>
          <key>WorkingDirectory</key>
          <string>#{var}</string>
          <key>StandardErrorPath</key>
          <string>#{var}/log/vault.log</string>
          <key>StandardOutPath</key>
          <string>#{var}/log/vault.log</string>
        </dict>
      </plist>
    EOS
  end

  test do
    pid = fork { exec bin/"vault", "server", "-dev" }
    sleep 1
    ENV.append "VAULT_ADDR", "http://127.0.0.1:8200"
    system bin/"vault", "status"
    Process.kill("TERM", pid)
  end
end
