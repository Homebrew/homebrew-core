class Repo < Formula
  include Language::Python::Shebang

  desc "Repository tool for Android development"
  homepage "https://source.android.com/source/developing.html"
  url "https://gerrit.googlesource.com/git-repo.git",
      tag:      "v2.35",
      revision: "c657844efe40b97700c3654989bdbe3a33e409d7"
  license "Apache-2.0"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "84087c9cc784bb062898df83c1417d65e6e819882003fa940f3f7dac95f4b39d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "84087c9cc784bb062898df83c1417d65e6e819882003fa940f3f7dac95f4b39d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "84087c9cc784bb062898df83c1417d65e6e819882003fa940f3f7dac95f4b39d"
    sha256 cellar: :any_skip_relocation, ventura:        "84087c9cc784bb062898df83c1417d65e6e819882003fa940f3f7dac95f4b39d"
    sha256 cellar: :any_skip_relocation, monterey:       "84087c9cc784bb062898df83c1417d65e6e819882003fa940f3f7dac95f4b39d"
    sha256 cellar: :any_skip_relocation, big_sur:        "84087c9cc784bb062898df83c1417d65e6e819882003fa940f3f7dac95f4b39d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e7ccc493548b15f02af19e8c0c907f0262e41e3104b8df8479d54bbb2f8a1e3f"
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
