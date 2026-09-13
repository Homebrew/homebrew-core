class Repo < Formula
  include Language::Python::Shebang

  desc "Repository tool for Android development"
  homepage "https://source.android.com/source/developing.html"
  url "https://gerrit.googlesource.com/git-repo.git",
      tag:      "v2.67",
      revision: "d27d6829a84f488b7253ea693dcc429076c33914"
  license "Apache-2.0"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "bcaf963ab39402cda680c69ecdb0934c0c93a60af933adce4049ba0786f58fb1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "bcaf963ab39402cda680c69ecdb0934c0c93a60af933adce4049ba0786f58fb1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "bcaf963ab39402cda680c69ecdb0934c0c93a60af933adce4049ba0786f58fb1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "bcaf963ab39402cda680c69ecdb0934c0c93a60af933adce4049ba0786f58fb1"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "00f3c1233eb2c3cbb86e75b0b4c08dce5b89ab03d17d45293160210d38b559a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "00f3c1233eb2c3cbb86e75b0b4c08dce5b89ab03d17d45293160210d38b559a9"
  end

  uses_from_macos "python"

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
