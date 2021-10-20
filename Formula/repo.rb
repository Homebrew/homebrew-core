class Repo < Formula
  include Language::Python::Shebang

  desc "Repository tool for Android development"
  homepage "https://source.android.com/source/developing.html"
  url "https://gerrit.googlesource.com/git-repo.git",
      tag:      "v2.17.2",
      revision: "03ff276cd70e78639232d2e878d972f15ebcd461"
  license "Apache-2.0"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, all: "056249d9a3a5a224af4eb24d938daef83611d31202e1209e814266e841a32e21"
  end

  depends_on "python@3.10"

  def install
    bin.install "repo"
    rewrite_shebang detected_python_shebang, bin/"repo"

    doc.install (buildpath/"docs").children
  end

  test do
    assert_match "usage:", shell_output("#{bin}/repo help 2>&1")
  end
end
