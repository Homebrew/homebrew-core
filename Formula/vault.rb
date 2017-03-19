# Please don't update this formula until the release is official via
# mailing list or blog post. There's a history of GitHub tags moving around.
# https://github.com/hashicorp/vault/issues/1051
class Vault < Formula
  desc "Secures, stores, and tightly controls access to secrets"
  homepage "https://vaultproject.io/"
  url "https://github.com/hashicorp/vault.git",
      :tag => "v0.7.0",
      :revision => "614deacfca3f3b7162bbf30a36d6fc7362cd47f0"
  head "https://github.com/hashicorp/vault.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "334905a9eaf657649c8df1282fb56239c75eb2afc2acfc4b6d2fa5004253edb1" => :sierra
    sha256 "6fe1bf96e2e9e508b66f4e2af6569c53bac78555aa0df5476dbf057d1dde85c3" => :el_capitan
    sha256 "ed6cb308d84c472d08a249ea051655ee8466f57658151e70c5870142697df6fb" => :yosemite
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
