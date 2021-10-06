class Repo < Formula
  include Language::Python::Shebang

  desc "Repository tool for Android development"
  homepage "https://source.android.com/source/developing.html"
  url "https://gerrit.googlesource.com/git-repo.git",
      tag:      "v2.16.8",
      revision: "0ec2029833ffa85400b729dc3b7039661eb42619"
  license "Apache-2.0"
  revision 1
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, all: "83e0d9547697d414580aec9fc2df6cac89d8699d36c73d86cdf9490bb7675e70"
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
