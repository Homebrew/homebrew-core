# Please don't update this formula until the release is official via
# mailing list or blog post. There's a history of GitHub tags moving around.
# https://github.com/hashicorp/vault/issues/1051
class Vault < Formula
  desc "Secures, stores, and tightly controls access to secrets"
  homepage "https://vaultproject.io/"
  url "https://github.com/hashicorp/vault.git",
      :tag => "v0.9.4",
      :revision => "2e2c89a3d8d2f4876c64dee6ba3d4a5e08691aee"
  head "https://github.com/hashicorp/vault.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b2538cf92c952f5e03d35f36a737bd1cfa81f4695ed6c5cad96a2ba83dffbd02" => :high_sierra
    sha256 "f547d4d8ac363cc6f9cf43f140e726ad5085a28c1a681f1ebd17583f8fd9588b" => :sierra
    sha256 "da37c24ba9a5da5a2242b08d3ba0c94d82065753de22327d4ee2b9661ce66c3f" => :el_capitan
  end

  option "with-dynamic", "Build dynamic binary with CGO_ENABLED=1"

  depends_on "go" => :build
  depends_on "gox" => :build

  def install
    ENV["GOPATH"] = buildpath

    contents = buildpath.children - [buildpath/".brew_home"]
    (buildpath/"src/github.com/hashicorp/vault").install contents

    (buildpath/"bin").mkpath

    cd "src/github.com/hashicorp/vault" do
      target = build.with?("dynamic") ? "dev-dynamic" : "dev"
      system "make", target
      bin.install "bin/vault"
      prefix.install_metafiles
    end
  end

  test do
    pid = fork { exec bin/"vault", "server", "-dev" }
    sleep 1
    ENV.append "VAULT_ADDR", "http://127.0.0.1:8200"
    system bin/"vault", "status"
    Process.kill("TERM", pid)
  end
end
