# Please don't update this formula until the release is official via
# mailing list or blog post. There's a history of GitHub tags moving around.
# https://github.com/hashicorp/vault/issues/1051
class Vault < Formula
  desc "Secures, stores, and tightly controls access to secrets"
  homepage "https://vaultproject.io/"
  url "https://github.com/hashicorp/vault.git",
      :tag => "v0.11.1",
      :revision => "8575f8fedcf8f5a6eb2b4701cb527b99574b5286"
  head "https://github.com/hashicorp/vault.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8806fdaa5f5a2f47e1b2d57155fd60ac13726f78d1d42a7014f15f1c197c09e7" => :mojave
    sha256 "9cc16a06957d684216d9aad5c84bb3ceede9f17e9079b95d9987336a0957a82b" => :high_sierra
    sha256 "c84556dd9b248ce04ab46a2326e0fdc315449f22a0e3dd40f90dc2794e62e867" => :sierra
    sha256 "b91d5050fa55adcbcc5d1775147b2b6e187bac94ea1001dbef6bf0a846cf9476" => :el_capitan
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
