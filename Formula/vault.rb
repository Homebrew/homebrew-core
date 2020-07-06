# Please don't update this formula until the release is official via
# mailing list or blog post. There's a history of GitHub tags moving around.
# https://github.com/hashicorp/vault/issues/1051
class Vault < Formula
  desc "Secures, stores, and tightly controls access to secrets"
  homepage "https://vaultproject.io/"
  url "https://github.com/hashicorp/vault.git",
      :tag      => "v1.4.3",
      :revision => "491533b63ec9c1343eac3a24d8a7558185a0acb7"
  license "MPL-2.0"
  head "https://github.com/hashicorp/vault.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f1da98de5119ba3ce6ffb11035b61363f352c609dd41c45180de4871a94d8a0d" => :catalina
    sha256 "9356e04df17bcb53842b27282f6247e460ef1db55673c67c8678e3c0b36ed3b6" => :mojave
    sha256 "d3d99896a98b9b1dd9826bd692ad136caa45d9a7e2d460cca722d8f164a0b4ab" => :high_sierra
  end

  depends_on "go" => :build
  depends_on "gox" => :build
  depends_on "node@10" => :build
  depends_on "yarn" => :build

  def install
    ENV["GOPATH"] = buildpath

    contents = buildpath.children - [buildpath/".brew_home"]
    (buildpath/"src/github.com/hashicorp/vault").install contents

    (buildpath/"bin").mkpath

    ENV.prepend_path "PATH", buildpath/"bin"

    cd "src/github.com/hashicorp/vault" do
      system "make", "bootstrap", "static-dist", "dev-ui"
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
