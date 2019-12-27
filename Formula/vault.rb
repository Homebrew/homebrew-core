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
    sha256 "157a98c8c0437a07bb91f23e0f466077689c54fa0fc83bb6291972ed3fb7661e" => :catalina
    sha256 "7ff366fc8db6a9b9bce7cdc44725b0c706498057c25aaa8addb38c60d0c0fcdc" => :mojave
    sha256 "023fc73fcbc9b28e58bf1ce180b8f26db46df9babaa26c314073fd076213b828" => :high_sierra
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
