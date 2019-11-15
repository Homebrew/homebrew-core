# Please don't update this formula until the release is official via
# mailing list or blog post. There's a history of GitHub tags moving around.
# https://github.com/hashicorp/vault/issues/1051
class Vault < Formula
  desc "Secures, stores, and tightly controls access to secrets"
  homepage "https://vaultproject.io/"
  url "https://github.com/hashicorp/vault.git",
      :tag      => "v1.3.0",
      :revision => "0f5c835d1cf91c00d01cb29a0048732d91357afa"
  head "https://github.com/hashicorp/vault.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "85c55dbc7851cecf723a23b23907fb5874f72254cf8e9b039f811f31d94cec6d" => :catalina
    sha256 "520b0924b40384d5149aa71533982c4f1c91b4063296641f32af652a5c65dbea" => :mojave
    sha256 "323c61e661e4f55f7a5387877fd5c3537650cfaa1fe71b1150d2d8943a83c8e2" => :high_sierra
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
