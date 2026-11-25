class Repo < Formula
  include Language::Python::Shebang

  desc "Repository tool for Android development"
  homepage "https://source.android.com/source/developing.html"
  url "https://gerrit.googlesource.com/git-repo.git",
      tag:      "v2.74.1",
      revision: "83eb32ef8758d5f89bdc7237b7513e40cadd1409"
  license "Apache-2.0"
  version_scheme 1

  bottle do
    manifest_sha256 "4831cbeb31a51c60fd8ba6d2eb74f2108a1c2e384cc467ce9526024d7bf9daf5"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2f7bc41ee0fb39a970d59309859847a3d9a45b826fb678bb5884e1083df0e906"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2f7bc41ee0fb39a970d59309859847a3d9a45b826fb678bb5884e1083df0e906"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2f7bc41ee0fb39a970d59309859847a3d9a45b826fb678bb5884e1083df0e906"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "73698f0c246d724491ca99f15d4d4e52ecae81d67567bb01d355732108220e00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "73698f0c246d724491ca99f15d4d4e52ecae81d67567bb01d355732108220e00"
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
