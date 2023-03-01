class Repo < Formula
  include Language::Python::Shebang

  desc "Repository tool for Android development"
  homepage "https://source.android.com/source/developing.html"
  url "https://gerrit.googlesource.com/git-repo.git",
      tag:      "v2.32",
      revision: "7fa149b47a980779f02ccaf1d1dbd5af5ce9abc7"
  license "Apache-2.0"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9404e919d2f51d27981802103ab75d2c75a50fbceb8e78ae3b09b6e0ac5013b6"
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
