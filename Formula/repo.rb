class Repo < Formula
  desc "Repository tool for Android development"
  homepage "https://source.android.com/source/developing.html"
  url "https://github.com/GerritCodeReview/git-repo.git",
      tag:      "v2.8",
      revision: "60fc51bb1dcf8970189a544c2ca75f2cdcfdb6f8"
  license "Apache-2.0"
  version_scheme 1

  bottle :unneeded

  def install
    bin.install "repo"
    doc.install (buildpath/"docs").children
  end

  test do
    assert_match "usage:", shell_output("#{bin}/repo help 2>&1")
  end
end
