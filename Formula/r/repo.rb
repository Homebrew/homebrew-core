class Repo < Formula
  include Language::Python::Shebang

  desc "Repository tool for Android development"
  homepage "https://source.android.com/source/developing.html"
  url "https://gerrit.googlesource.com/git-repo.git",
      tag:      "v2.73",
      revision: "d7c431b9968d928373fe9b463a51d304d3b2c48a"
  license "Apache-2.0"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c1870c6e28e71e19c782ff72d40ddefda0509f1ea260ed00d2615478c4630146"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c1870c6e28e71e19c782ff72d40ddefda0509f1ea260ed00d2615478c4630146"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c1870c6e28e71e19c782ff72d40ddefda0509f1ea260ed00d2615478c4630146"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "141d1ef9ea09c18f3e644e7dd196e3902017c43847f6983732d437efb4526472"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "141d1ef9ea09c18f3e644e7dd196e3902017c43847f6983732d437efb4526472"
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
