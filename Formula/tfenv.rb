class Tfenv < Formula
  desc "Terraform version manager inspired by rbenv"
  homepage "https://github.com/tfutils/tfenv"
  url "https://github.com/tfutils/tfenv/archive/v3.0.0.tar.gz"
  sha256 "463132e45a211fa3faf85e62fdfaa9bb746343ff1954ccbad91cae743df3b648"
  license "MIT"
  head "https://github.com/tfutils/tfenv.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4905c2390b0254348be44da1c4a05b3d8bf4d8704b94d16b739d64fd4709784b"
  end

  uses_from_macos "unzip"

  on_macos do
    depends_on "grep"
  end

  conflicts_with "terraform", because: "tfenv symlinks terraform binaries"

  def install
    prefix.install %w[bin lib libexec share]
  end

  test do
    assert_match "0.10.0", shell_output("#{bin}/tfenv list-remote")
    with_env(TFENV_TERRAFORM_VERSION: "0.10.0", TF_AUTO_INSTALL: "false") do
      assert_equal "0.10.0", shell_output("#{bin}/tfenv version-name").strip
    end
  end
end
