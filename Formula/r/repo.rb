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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5cb8abb1c77d51b57351d47b396db5eec7827b83c59f9cf81a70140edaff47fc"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5cb8abb1c77d51b57351d47b396db5eec7827b83c59f9cf81a70140edaff47fc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5cb8abb1c77d51b57351d47b396db5eec7827b83c59f9cf81a70140edaff47fc"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "310d78bb98cce81a29ef5b5a5c36e944e2514626885023e13df2f232e44e214f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "310d78bb98cce81a29ef5b5a5c36e944e2514626885023e13df2f232e44e214f"
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
