class Repo < Formula
  include Language::Python::Shebang

  desc "Repository tool for Android development"
  homepage "https://source.android.com/source/developing.html"
  url "https://gerrit.googlesource.com/git-repo.git",
      tag:      "v2.37",
      revision: "83c66ec661e39e47795086a5d26d0f3782ac1d49"
  license "Apache-2.0"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "aa0fc20511ba1bca5a23528663cc0be16955d6ed77626d095353b770c2662a0d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aa0fc20511ba1bca5a23528663cc0be16955d6ed77626d095353b770c2662a0d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aa0fc20511ba1bca5a23528663cc0be16955d6ed77626d095353b770c2662a0d"
    sha256 cellar: :any_skip_relocation, sonoma:         "aa0fc20511ba1bca5a23528663cc0be16955d6ed77626d095353b770c2662a0d"
    sha256 cellar: :any_skip_relocation, ventura:        "aa0fc20511ba1bca5a23528663cc0be16955d6ed77626d095353b770c2662a0d"
    sha256 cellar: :any_skip_relocation, monterey:       "aa0fc20511ba1bca5a23528663cc0be16955d6ed77626d095353b770c2662a0d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "25f410f3a6ba371a2eb2b46e2f18197a7f02e1e0752dee16ce1aaae90759eaf0"
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
