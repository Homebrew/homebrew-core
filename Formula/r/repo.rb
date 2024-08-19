class Repo < Formula
  include Language::Python::Shebang

  desc "Repository tool for Android development"
  homepage "https://source.android.com/source/developing.html"
  url "https://gerrit.googlesource.com/git-repo.git",
      tag:      "v2.46",
      revision: "0444ddf78e3026056ee3786119e595909c039ff2"
  license "Apache-2.0"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fbd3d930b5b82d64171586736a1ea8ccc1a1ca3ef20f5b988b58cd00100b5016"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fbd3d930b5b82d64171586736a1ea8ccc1a1ca3ef20f5b988b58cd00100b5016"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fbd3d930b5b82d64171586736a1ea8ccc1a1ca3ef20f5b988b58cd00100b5016"
    sha256 cellar: :any_skip_relocation, sonoma:         "fbd3d930b5b82d64171586736a1ea8ccc1a1ca3ef20f5b988b58cd00100b5016"
    sha256 cellar: :any_skip_relocation, ventura:        "fbd3d930b5b82d64171586736a1ea8ccc1a1ca3ef20f5b988b58cd00100b5016"
    sha256 cellar: :any_skip_relocation, monterey:       "fbd3d930b5b82d64171586736a1ea8ccc1a1ca3ef20f5b988b58cd00100b5016"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1c176c0e0a2ff1c1412af90e72e806fa8dc3202be400b31eba3aa835c6ed202e"
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
