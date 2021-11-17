class Secman < Formula
  desc "👊 Human-friendly and amazing secrets manager"
  homepage "https://secman.dev/docs/cli"
  url "https://cli-files.secman.dev/secman-v6.0.71/secman-v6.0.71.tar.gz"
  sha256 "2a9c03df9b444e9c110b640c2e22ef4db147623cb728f7b2c68f2bc488d0e230"
  license "MIT"
  head "https://github.com/scmn-dev/secman.git", branch: "main"

  livecheck do
    url "https://github.com/scmn-dev/secman/releases/latest"
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
  end

  depends_on "node"

  def install
    inreplace "bin/secman", /^CLIENT_HOME=/, "export SECMAN_OCLIF_CLIENT_HOME=#{lib/"client"}\nCLIENT_HOME="
    inreplace "bin/secman", "\"$DIR/node\"", Formula["node"].opt_bin/"node"
    libexec.install Dir["*"]
    bin.install_symlink libexec/"bin/secman"
  end

  test do
    system bin/"secman", "init"
    system bin/"secman", "crypto", "HOMEBREW"
    assert_match "secman v#{version} (2021-11-13)\nhttps://github.com/scmn-dev/secman/releases/tag/v#{version}",
    shell_output("#{bin}/secman --version")
  end
end
