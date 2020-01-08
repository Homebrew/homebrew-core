# Please don't update this formula until the release is official via
# mailing list or blog post. There's a history of GitHub tags moving around.
# https://github.com/hashicorp/vault/issues/1051
class Vault < Formula
  desc "Secures, stores, and tightly controls access to secrets"
  homepage "https://vaultproject.io/"
  url "https://github.com/hashicorp/vault.git",
      :tag      => "v1.3.1",
      :revision => "cec3fdeda0077efb0a6b0343908322f806a1dfef"
  head "https://github.com/hashicorp/vault.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1ed9c5a094f555814cd9d502e319a8e3bf97b969a9290b55219b176b5c663b37" => :catalina
    sha256 "48227c668a41b4b436c480517ff44f550dcf17b63748233bd25303c09b279319" => :mojave
    sha256 "09deb60a118a61a29f17d0ef27442be32e63cc0e07465087418fb3b4ca667608" => :high_sierra
  end

  depends_on "go@1.12" => :build
  depends_on "gox" => :build

  def install
    ENV["GOPATH"] = buildpath

    contents = buildpath.children - [buildpath/".brew_home"]
    (buildpath/"src/github.com/hashicorp/vault").install contents

    (buildpath/"bin").mkpath

    cd "src/github.com/hashicorp/vault" do
      system "make", "dev"
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
