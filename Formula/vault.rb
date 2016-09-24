require "language/go"

# Please don't update this formula until the release is official via
# mailing list or blog post. There's a history of GitHub tags moving around.
# https://github.com/hashicorp/vault/issues/1051
class Vault < Formula
  desc "Secures, stores, and tightly controls access to secrets"
  homepage "https://vaultproject.io/"
  url "https://github.com/hashicorp/vault.git",
      :tag => "v0.6.1",
      :revision => "182ba68a9589d4cef95234134aaa498a686e3de3"
  head "https://github.com/hashicorp/vault.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2bfb1356a901e363db2042b922c2e9448e195b0f4d5554792055eda33e964823" => :sierra
    sha256 "1c993a1eb4daea265bcf45a110f83d74fd32fe1b31cfb14ba7adb814a0bc2ff3" => :el_capitan
    sha256 "8bdab2103c4b2aad9f6b11ee315c20cde6d4129afaa2ef49e8506b4a87301ed2" => :yosemite
    sha256 "4f29ee4754dbb55812f684f724e4ee6d0e8e4ebb5e547d209f6f41bbb8681ce0" => :mavericks
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
