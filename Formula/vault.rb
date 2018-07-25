# Please don't update this formula until the release is official via
# mailing list or blog post. There's a history of GitHub tags moving around.
# https://github.com/hashicorp/vault/issues/1051
class Vault < Formula
  desc "Secures, stores, and tightly controls access to secrets"
  homepage "https://vaultproject.io/"
  url "https://github.com/hashicorp/vault.git",
      :tag => "v0.10.4",
      :revision => "e21712a687889de1125e0a12a980420b1a4f72d3"
  head "https://github.com/hashicorp/vault.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d4b26094618edd5f4dd59407ea704b9ba93ff520b159b689b69f5ecd4381b926" => :high_sierra
    sha256 "694f5a117e134c7df2d448de5ddb66927e82d54190fe4947e375aea995a2664f" => :sierra
    sha256 "90e9a457445ba7df2a693a45b114d9de7c71012a3bc387be6efa42909870a3f9" => :el_capitan
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
