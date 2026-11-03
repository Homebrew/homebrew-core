class Repo < Formula
  include Language::Python::Shebang

  desc "Repository tool for Android development"
  homepage "https://source.android.com/source/developing.html"
  url "https://gerrit.googlesource.com/git-repo.git",
      tag:      "v2.72",
      revision: "365629015667e04739f59070e745548a728549c8"
  license "Apache-2.0"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1df0e670c469b5c7cac6e2754c589f98593c2dca0795e84562bae85282219ba3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1df0e670c469b5c7cac6e2754c589f98593c2dca0795e84562bae85282219ba3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1df0e670c469b5c7cac6e2754c589f98593c2dca0795e84562bae85282219ba3"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e0af7cd8e7ef0da54e491f3abbd08c33742b235daf4c06b36b0c7469b1a38c8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "e0af7cd8e7ef0da54e491f3abbd08c33742b235daf4c06b36b0c7469b1a38c8d"
  end

  uses_from_macos "python"

  deny_network_access!

  def install
    bin.install "repo"
    doc.install (buildpath/"docs").children
    bash_completion.install "completion.bash" => "repo" if OS.linux? # needs GNU sed
    zsh_completion.install "completion.zsh" => "_repo"
    man1.install Utils::Gzip.compress(*Dir["man/*.1"])

    rewrite_shebang detected_python_shebang(use_python_from_path: true), bin/"repo"
  end

  test do
    assert_match "usage:", shell_output("#{bin}/repo help 2>&1")
  end
end
