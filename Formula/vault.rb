# Please don't update this formula until the release is official via
# mailing list or blog post. There's a history of GitHub tags moving around.
# https://github.com/hashicorp/vault/issues/1051
class Vault < Formula
  desc "Secures, stores, and tightly controls access to secrets"
  homepage "https://vaultproject.io/"
  url "https://github.com/hashicorp/vault.git",
      :tag => "v0.11.0",
      :revision => "87492f9258e0227f3717e3883c6a8be5716bf564"
  head "https://github.com/hashicorp/vault.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0047ff36f445a5d75354a72c9c4f0405efdc054757281e6d948b348f7e9e07e0" => :mojave
    sha256 "0aaf0491b1f2e91e7a31ee27ef2b657de58507e23a5fd170624f6dec021b802e" => :high_sierra
    sha256 "d703006b5b3088dd95201eec355ef6bf138fadbe947096380130e896bb136371" => :sierra
    sha256 "68667971e3f0ad7e9aba676d010607e6eefd5d57bef5e3b7a23108fa3cfb8ba5" => :el_capitan
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
      system "make", "fmt"
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
