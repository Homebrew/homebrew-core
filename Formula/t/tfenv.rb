class Tfenv < Formula
  desc "Terraform version manager inspired by rbenv"
  homepage "https://github.com/tfutils/tfenv"
  url "https://github.com/tfutils/tfenv/archive/refs/tags/v3.2.2.tar.gz"
  sha256 "c9c8b2e2588cf026aafa9803dfdefdfc7aa258577c24ea9624fe53f764edea47"
  license "MIT"
  head "https://github.com/tfutils/tfenv.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f28386d9f8bcedb39429c6abf417133cd80a10bd1935c6286bcfe4871b8c0887"
  end

  uses_from_macos "unzip"

  on_macos do
    depends_on "grep"
  end

  conflicts_with "tenv", because: "tfenv symlinks terraform binaries"

  def install
    prefix.install %w[bin lib libexec share]
    bin.env_script_all_files libexec,
                             TFENV_CONFIG_DIR: "${TFENV_CONFIG_DIR:-${XDG_CONFIG_HOME:-${HOME}/.config}/tfenv}"
  end

  test do
    assert_match "0.10.0", shell_output("#{bin}/tfenv list-remote")
    with_env(TFENV_TERRAFORM_VERSION: "0.10.0", TF_AUTO_INSTALL: "false") do
      assert_equal "0.10.0", shell_output("#{bin}/tfenv version-name").strip
    end
  end
end
