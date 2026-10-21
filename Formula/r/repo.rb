class Repo < Formula
  include Language::Python::Shebang

  desc "Repository tool for Android development"
  homepage "https://source.android.com/source/developing.html"
  url "https://gerrit.googlesource.com/git-repo.git",
      tag:      "v2.70",
      revision: "46e9866ca0f161604bd45a0c3b7c7887c9415dcb"
  license "Apache-2.0"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f6cc58d5d15a4b80809a6779c27168ba0de4e53726b66ee639707b64f8e542f9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f6cc58d5d15a4b80809a6779c27168ba0de4e53726b66ee639707b64f8e542f9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f6cc58d5d15a4b80809a6779c27168ba0de4e53726b66ee639707b64f8e542f9"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "23b1cbba596d3e0f737d2a02042969a95d624c4a6293fde61575fdbce303de3c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "23b1cbba596d3e0f737d2a02042969a95d624c4a6293fde61575fdbce303de3c"
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
