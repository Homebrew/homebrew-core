# Please don't update this formula until the release is official via
# mailing list or blog post. There's a history of GitHub tags moving around.
# https://github.com/hashicorp/vault/issues/1051
class Vault < Formula
  desc "Secures, stores, and tightly controls access to secrets"
  homepage "https://vaultproject.io/"
  url "https://github.com/hashicorp/vault.git",
      :tag => "v0.9.1",
      :revision => "87b6919dea55da61d7cd444b2442cabb8ede8ab1"
  head "https://github.com/hashicorp/vault.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "39f93e90a4430ab907f8b294ba92b522309e8829ba08177597dd9e669578e60c" => :high_sierra
    sha256 "3d4266f1f1d358d322fb5113d673cf54928a15d85d280f4a8aa0f39a66df3237" => :sierra
    sha256 "c2341752bd00f51def28ffe6908cb6006eab027050ed7649437e327e58fe4e8d" => :el_capitan
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
