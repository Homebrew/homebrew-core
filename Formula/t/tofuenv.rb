class Tofuenv < Formula
  desc "OpenTofu version manager inspired by tfenv"
  homepage "https://tofuutils.github.io/tofuenv/"
  url "https://github.com/tofuutils/tofuenv/archive/refs/tags/v1.0.7.tar.gz"
  sha256 "047c6a01a0d4c7ded2cf126ae1e891bb3479b2544ec2d2f0d3951de2d08f6c7d"
  license "MIT"
  head "https://github.com/tofuutils/tofuenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3febcab9a632034fdedf2d4ae0105d4425bcdb12ac73e58b586a1ddf6db36487"
  end

  uses_from_macos "unzip"

  on_macos do
    depends_on "grep"
    depends_on "jq"
  end

  conflicts_with "opentofu", "tenv", because: "both install tofu binary"

  def install
    prefix.install %w[bin lib libexec share]
  end

  test do
    assert_match "1.8.7", shell_output("#{bin}/tofuenv list-remote")
    with_env(TOFUENV_TOFU_VERSION: "1.8.7", TF_AUTO_INSTALL: "false") do
      assert_equal "1.8.7", shell_output("#{bin}/tofuenv version-name").strip
    end
  end
end
