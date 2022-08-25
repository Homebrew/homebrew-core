class Repo < Formula
  include Language::Python::Shebang

  desc "Repository tool for Android development"
  homepage "https://source.android.com/source/developing.html"
  url "https://gerrit.googlesource.com/git-repo.git",
      tag:      "v2.29.1",
      revision: "4112c07688d0e0e568478e9f42be349bdd511d45"
  license "Apache-2.0"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, all: "10c36d9f4c20d38bbaff9763f7980726b8c0bca1bddaa9908d0b7796998c9cba"
  end

  uses_from_macos "python"

  def install
    bin.install "repo"
    doc.install (buildpath/"docs").children

    # Need Catalina+ for `python3`.
    return if OS.mac? && MacOS.version < :catalina

    rewrite_shebang detected_python_shebang, bin/"repo"
  end

  test do
    assert_match "usage:", shell_output("#{bin}/repo help 2>&1")
  end
end
