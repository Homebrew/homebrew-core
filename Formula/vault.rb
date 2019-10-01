# Please don't update this formula until the release is official via
# mailing list or blog post. There's a history of GitHub tags moving around.
# https://github.com/hashicorp/vault/issues/1051
class Vault < Formula
  desc "Secures, stores, and tightly controls access to secrets"
  homepage "https://vaultproject.io/"
  url "https://github.com/hashicorp/vault.git",
      :tag      => "v1.2.3",
      :revision => "c14bd9a2b1d2c20f15b9f93f5c2d487507bb8a2f"
  head "https://github.com/hashicorp/vault.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "994bef4df9f223aeaa939d3ee7aa7533a029b61b735612a4c560511cef7186b0" => :catalina
    sha256 "dafe6bb7f3f7aaa6d0b6021d512b324d746372fe2c1dd255ecddf576d7692e27" => :mojave
    sha256 "44de8bfecf3e5c2ef5ecb6d484607655ab33f37298b14045efb74d8662903796" => :high_sierra
    sha256 "580ae0fcad83286e13bcff0afdfca0aa0d116e2c6a2370cff31320f2df895d15" => :sierra
  end

  depends_on "go" => :build
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
