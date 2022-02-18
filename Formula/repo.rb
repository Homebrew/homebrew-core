class Repo < Formula
  include Language::Python::Shebang

  desc "Repository tool for Android development"
  homepage "https://source.android.com/source/developing.html"
  url "https://gerrit.googlesource.com/git-repo.git",
      tag:      "v2.22",
      revision: "cc879a97c3e2614d19b15b4661c3cab4d33139c9"
  license "Apache-2.0"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, all: "66cdea4ac574ef3f8cedcf0a6d64f9f1bff97847ea631d37efae5e76f8ecb9f4"
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
