class TkeySshAgent < Formula
  desc "SSH agent for use with the TKey security stick"
  homepage "https://tillitis.se/"
  url "https://github.com/tillitis/tkey-ssh-agent/archive/refs/tags/v0.0.6.tar.gz"
  sha256 "b0ace3e21b9fc739a05c0049131f7386efa766936576d56c206d3abd0caed668"
  license "GPL-2.0-only"
  revision 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d1693eb4c1246a0d6afd2dd24902f34cf8e8f92e3009c0b95325e29f1e576e0e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "79f70b9d9de1d77985992cb64e3a455e6863a7a2a0697b1295a31bada78b544d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4b0c368897a67c585ec79ccef5e95940637a8bbcf47db37037b6f29f652606f8"
    sha256 cellar: :any_skip_relocation, sonoma:         "8f62ea8147b984c3efb65831704ab4c8de14c65622ad5fb94ee3aeebfc561fb0"
    sha256 cellar: :any_skip_relocation, ventura:        "9ef52e8c902faaa44b64409de0baea593a7ac1075ab179308cf926109deba6b7"
    sha256 cellar: :any_skip_relocation, monterey:       "60d5a0a4f086a93f1c994209604cfa2a4e4b304b6e6b8025f5d1561551009c6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6330e99e8ada1967925e768f19ab93405c445a18876baddd43d8d8cd9d91a3c0"
  end

  depends_on "go" => :build

  on_macos do
    depends_on "pinentry-mac"
  end

  on_linux do
    depends_on "pinentry"
  end

  resource "signerapp" do
    url "https://github.com/tillitis/tillitis-key1-apps/releases/download/v0.0.6/signer.bin"
    sha256 "639bdba7e61c3e1d551e9c462c7447e4908cf0153edaebc2e6843c9f78e477a6"
  end

  # patch `go.bug.st/serial` to v1.6.2 to fix `cannot define new methods on non-local type C.CFTypeRef` error
  patch :DATA

  def install
    resource("signerapp").stage("./cmd/tkey-ssh-agent/app.bin")
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/tkey-ssh-agent"
    man1.install "system/tkey-ssh-agent.1"
  end

  def post_install
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
    assert_predicate socket, :exist?
  end
end

__END__
diff --git a/go.mod b/go.mod
index aaf7fbd..22b4ff6 100644
--- a/go.mod
+++ b/go.mod
@@ -6,7 +6,7 @@ require (
 	github.com/gen2brain/beeep v0.0.0-20220909211152-5a9ec94374f6
 	github.com/spf13/pflag v1.0.5
 	github.com/twpayne/go-pinentry-minimal v0.0.0-20220113210447-2a5dc4396c2a
-	go.bug.st/serial v1.5.0
+	go.bug.st/serial v1.6.2
 	golang.org/x/crypto v0.5.0
 	golang.org/x/term v0.4.0
 )
diff --git a/go.sum b/go.sum
index f0652fe..805352e 100644
--- a/go.sum
+++ b/go.sum
@@ -26,6 +26,8 @@ github.com/twpayne/go-pinentry-minimal v0.0.0-20220113210447-2a5dc4396c2a h1:a1b
 github.com/twpayne/go-pinentry-minimal v0.0.0-20220113210447-2a5dc4396c2a/go.mod h1:ARJJXqNuaxVS84jX6ST52hQh0TtuQZWABhTe95a6BI4=
 go.bug.st/serial v1.5.0 h1:ThuUkHpOEmCVXxGEfpoExjQCS2WBVV4ZcUKVYInM9T4=
 go.bug.st/serial v1.5.0/go.mod h1:UABfsluHAiaNI+La2iESysd9Vetq7VRdpxvjx7CmmOE=
+go.bug.st/serial v1.6.2 h1:kn9LRX3sdm+WxWKufMlIRndwGfPWsH1/9lCWXQCasq8=
+go.bug.st/serial v1.6.2/go.mod h1:UABfsluHAiaNI+La2iESysd9Vetq7VRdpxvjx7CmmOE=
 golang.org/x/crypto v0.5.0 h1:U/0M97KRkSFvyD/3FSmdP5W5swImpNgle/EHFhOsQPE=
 golang.org/x/crypto v0.5.0/go.mod h1:NK/OQwhpMQP3MwtdjgLlYHnH9ebylxKWv3e0fK+mkQU=
 golang.org/x/sys v0.0.0-20220319134239-a9b59b0215f8/go.mod h1:oPkhp1MJrh7nUepCBck5+mAzfO9JrbApNNgaTdGDITg=
