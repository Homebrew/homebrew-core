class Repo < Formula
  desc "Repository tool for Android development"
  homepage "https://source.android.com/source/developing.html"
  url "https://gerrit.googlesource.com/git-repo.git",
      :tag      => "v1.13.8",
      :revision => "34bc5712eb7e09f9fc5b39ae78786775ad3023e8"
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
