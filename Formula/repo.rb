class Repo < Formula
  include Language::Python::Shebang

  desc "Repository tool for Android development"
  homepage "https://source.android.com/source/developing.html"
  url "https://gerrit.googlesource.com/git-repo.git",
      tag:      "v2.32",
      revision: "7fa149b47a980779f02ccaf1d1dbd5af5ce9abc7"
  license "Apache-2.0"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3fc56eb1a20b6b1a913d2bb0337a1765c36f2c1a6e57117371c9a6ba0224c8c3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3fc56eb1a20b6b1a913d2bb0337a1765c36f2c1a6e57117371c9a6ba0224c8c3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3fc56eb1a20b6b1a913d2bb0337a1765c36f2c1a6e57117371c9a6ba0224c8c3"
    sha256 cellar: :any_skip_relocation, ventura:        "3fc56eb1a20b6b1a913d2bb0337a1765c36f2c1a6e57117371c9a6ba0224c8c3"
    sha256 cellar: :any_skip_relocation, monterey:       "3fc56eb1a20b6b1a913d2bb0337a1765c36f2c1a6e57117371c9a6ba0224c8c3"
    sha256 cellar: :any_skip_relocation, big_sur:        "3fc56eb1a20b6b1a913d2bb0337a1765c36f2c1a6e57117371c9a6ba0224c8c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "49a37cd6d657b35b258055bb48d7e45048ea6c3d7114319e18a6ef2c20dce1a3"
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
