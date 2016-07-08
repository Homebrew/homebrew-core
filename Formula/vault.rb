require "language/go"

# Please don't update this formula until the release is official via
# mailing list or blog post. There's a history of GitHub tags moving around.
# https://github.com/hashicorp/vault/issues/1051
class Vault < Formula
  desc "Secures, stores, and tightly controls access to secrets"
  homepage "https://vaultproject.io/"
  url "https://github.com/hashicorp/vault.git",
      :tag => "v0.6.0-rebuild",
      :revision => "d2d0aa07d079836c9a5bd258479b019ca00eb6b8"
  head "https://github.com/hashicorp/vault.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9468465da2abefb10d5fae81c8bd2bb91f07e8074bc3b4cb67f65099b5540e70" => :el_capitan
    sha256 "55f4996c2801100f9ab896a628ef3cd42f08fe166a87a461424ba78abe2dbbec" => :yosemite
    sha256 "91c4e8315f40988ad94a0797488bf668b79289a0190357c8d5b0737a96003c8f" => :mavericks
  end

  option "with-test", "Run tests after compilation"

  depends_on "go" => :build

  go_resource "github.com/mitchellh/iochan" do
    url "https://github.com/mitchellh/iochan.git",
    :revision => "87b45ffd0e9581375c491fef3d32130bb15c5bd7"
  end

  go_resource "github.com/mitchellh/gox" do
    url "https://github.com/mitchellh/gox.git",
    :revision => "6e9ee79eab7bb1b84155379b3f94ff9a87b344e4"
  end

  def install
    ENV["GOPATH"] = buildpath

    contents = buildpath.children - [buildpath/".brew_home"]
    (buildpath/"src/github.com/hashicorp/vault").install contents

    ENV.prepend_create_path "PATH", buildpath/"bin"

    Language::Go.stage_deps resources, buildpath/"src"

    cd "src/github.com/mitchellh/gox" do
      system "go", "install"
    end

    cd "src/github.com/hashicorp/vault" do
      system "make", "dev"
      system "make", "test" if build.bottle? || build.with?("test")
      bin.install "bin/vault"
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
