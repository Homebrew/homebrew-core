class Repo < Formula
  include Language::Python::Shebang

  desc "Repository tool for Android development"
  homepage "https://source.android.com/source/developing.html"
  url "https://gerrit.googlesource.com/git-repo.git",
      tag:      "v2.44",
      revision: "fff1d2d74c2078b62cc9c2561330e41a842dc197"
  license "Apache-2.0"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1c1fb4a73b8eff677d7fa016c1dec3cf2158f519d5066e33d0c2454e8150635a"
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
