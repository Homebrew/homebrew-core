class Secman < Formula
  desc "👊 Human-friendly and amazing secrets manager"
  homepage "https://secman.dev/docs/cli"
  url "https://cli-files.secman.dev/secman-v6.0.71/secman-v6.0.71.tar.gz"
  sha256 "2a9c03df9b444e9c110b640c2e22ef4db147623cb728f7b2c68f2bc488d0e230"
  license "MIT"

  livecheck do
    url "https://github.com/scmn-dev/secman/releases/latest"
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
  end

  def install
    inreplace "bin/secman", /^CLIENT_HOME=/, "export SECMAN_OCLIF_CLIENT_HOME=#{lib/"client"}\nCLIENT_HOME="
    libexec.install Dir["*"]
    bin.install_symlink libexec/"bin/secman"

    # this variable is used for `update` command
    # https://github.com/scmn-dev/secman/blob/main/src/commands/update.ts#L48
    ENV["SM_PROVIDER"] = "brew"
  end

  test do
    system bin/"secman", "init"
    system bin/"secman", "crypto", "HOMEBREW"
    assert_match "secman v6.0.71 (2021-11-13)\nhttps://github.com/scmn-dev/secman/releases/tag/v6.0.71",
    shell_output("#{bin}/secman --version")
  end
end
