class Repo < Formula
  include Language::Python::Shebang

  desc "Repository tool for Android development"
  homepage "https://source.android.com/source/developing.html"
  url "https://gerrit.googlesource.com/git-repo.git",
      tag:      "v2.36.1",
      revision: "1e9f7b9e9ef473305d10a26a48138bc6ad38ccf6"
  license "Apache-2.0"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5e819d9158eccdd758c62ca3572deef8cb6c4f0861b0f89c77603dfb24dcee1f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5e819d9158eccdd758c62ca3572deef8cb6c4f0861b0f89c77603dfb24dcee1f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5e819d9158eccdd758c62ca3572deef8cb6c4f0861b0f89c77603dfb24dcee1f"
    sha256 cellar: :any_skip_relocation, ventura:        "5e819d9158eccdd758c62ca3572deef8cb6c4f0861b0f89c77603dfb24dcee1f"
    sha256 cellar: :any_skip_relocation, monterey:       "5e819d9158eccdd758c62ca3572deef8cb6c4f0861b0f89c77603dfb24dcee1f"
    sha256 cellar: :any_skip_relocation, big_sur:        "5e819d9158eccdd758c62ca3572deef8cb6c4f0861b0f89c77603dfb24dcee1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e5875e636e53b722f87fc5863f3c4e65f15eef529d88efc9b5e38bd5155e0086"
  end

  uses_from_macos "python"

  def install
    bin.install "repo"
    doc.install (buildpath/"docs").children

    # Need Catalina+ for `python3`.
    return if OS.mac? && MacOS.version < :catalina

    rewrite_shebang detected_python_shebang(use_python_from_path: true), bin/"repo"
  end

  test do
    assert_match "usage:", shell_output("#{bin}/repo help 2>&1")
  end
end
