class Repo < Formula
  desc "Repository tool for Android development"
  homepage "https://source.android.com/source/developing.html"
  url "https://github.com/GerritCodeReview/git-repo.git",
      :tag      => "v2.6",
      :revision => "2fe84e17b923f29139dc6056756ab30078864c18"
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
