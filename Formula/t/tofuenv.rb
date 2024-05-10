class Tofuenv < Formula
  desc "OpenTofu version manager inspired by tfenv"
  homepage "https://github.com/tofuutils/tofuenv"
  url "https://github.com/tofuutils/tofuenv/archive/refs/tags/v1.0.6.tar.gz"
  sha256 "a7940ce5ae2700c48df4a7c396ea68f8d37067844c1f80eb55936c39d42edf6f"
  license "MIT"
  head "https://github.com/tofuutils/tofuenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ee28b005988edd5b72576d1019be4049ea7d09bb54f79644dfd56b88242017ac"
  end

  uses_from_macos "unzip"

  on_macos do
    depends_on "grep"
    depends_on "jq"
  end

  def install
    prefix.install %w[bin lib libexec share]
  end

  test do
    assert_match "1.6.0-rc1", shell_output("#{bin}/tofuenv list-remote")
    with_env(TOFUENV_TOFU_VERSION: "1.6.0-rc1", TF_AUTO_INSTALL: "false") do
      assert_equal "1.6.0-rc1", shell_output("#{bin}/tofuenv version-name").strip
    end
  end
end
