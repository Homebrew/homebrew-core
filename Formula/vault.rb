require "language/go"

# Please don't update this formula until the release is official via
# mailing list or blog post. There's a history of GitHub tags moving around.
# https://github.com/hashicorp/vault/issues/1051
class Vault < Formula
  desc "Secures, stores, and tightly controls access to secrets"
  homepage "https://vaultproject.io/"
  url "https://github.com/hashicorp/vault.git",
      :tag => "v0.6.3",
      :revision => "27aff4397f6fe6cf741fbc967adf863347c0beaf"
  head "https://github.com/hashicorp/vault.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a0e956cad79a349755610aa3b2fd9c84abbd2fa7c3f0a6faef496880b04d07bf" => :sierra
    sha256 "ef2c6c35dd6d2765b099a5f46b7c815ad48c7f8e5a92875c0254b0063f6ef098" => :el_capitan
    sha256 "af8867dfa593c61bf441fccb3e30611364a13fcd5bfed4c297860f109ad4e560" => :yosemite
  end

  depends_on "go" => :build

  go_resource "github.com/mitchellh/iochan" do
    url "https://github.com/mitchellh/iochan.git",
        :revision => "87b45ffd0e9581375c491fef3d32130bb15c5bd7"
  end

  go_resource "github.com/mitchellh/gox" do
    url "https://github.com/mitchellh/gox.git",
        :revision => "c9740af9c6574448fd48eb30a71f964014c7a837"
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
