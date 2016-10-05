class Repo < Formula
  desc "Repository tool for Android development"
  homepage "https://source.android.com/source/developing.html"
  url "https://gerrit.googlesource.com/git-repo.git",
      :tag => "v1.12.37",
      :revision => "eceeb1b1f5edb0f42e690bffdf81828abd8ea7fe"
  version_scheme 1

  bottle :unneeded

  def install
    bin.install "repo"
    doc.install (buildpath/"docs").children
  end

  test do
    assert_match "usage:", shell_output("#{bin}/repo help 2>&1", 1)
  end
end
