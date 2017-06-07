# Please don't update this formula until the release is official via
# mailing list or blog post. There's a history of GitHub tags moving around.
# https://github.com/hashicorp/vault/issues/1051
class Vault < Formula
  desc "Secures, stores, and tightly controls access to secrets"
  homepage "https://vaultproject.io/"
  url "https://github.com/hashicorp/vault.git",
      :tag => "v0.7.2",
      :revision => "d28dd5a018294562dbc9a18c95554d52b5d12390"
  head "https://github.com/hashicorp/vault.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0e14f1e8342b144f154a62274b424b50d44eabeda1aa348563c34fb0a930d52c" => :sierra
    sha256 "44657829481a071a9d52f52f70b68c222c906fc1b18a835f23e2e37d36bae9db" => :el_capitan
    sha256 "993b4a4a8105a707ea1cfc7f32eaa5c5c32fed290d4dbbaa8bff61e5aa14810a" => :yosemite
  end

  depends_on "go" => :build

  def install
    dir = buildpath/"src/github.com/hashicorp/vault"
    dir.install buildpath.children - [buildpath/".brew_home"]

    ENV["GOPATH"] = buildpath
    ENV.prepend_create_path "PATH", buildpath/"bin"

    cd dir do
      arch = MacOS.prefer_64_bit? ? "amd64" : "386"
      ENV["XC_OS"] = "darwin"
      ENV["XC_ARCH"] = arch
      system "make", "bootstrap"
      system "make", "bin"

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
