class Repo < Formula
  include Language::Python::Shebang

  desc "Repository tool for Android development"
  homepage "https://source.android.com/source/developing.html"
  url "https://gerrit.googlesource.com/git-repo.git",
      tag:      "v2.34.1",
      revision: "945c006f406550add8a3cad32ada0791f5a15c53"
  license "Apache-2.0"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7b7694c86ac2c864dbd73e5a3db1fcbbf65d3ad5acdcba822dfcf1f449ab60af"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7b7694c86ac2c864dbd73e5a3db1fcbbf65d3ad5acdcba822dfcf1f449ab60af"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7b7694c86ac2c864dbd73e5a3db1fcbbf65d3ad5acdcba822dfcf1f449ab60af"
    sha256 cellar: :any_skip_relocation, ventura:        "7b7694c86ac2c864dbd73e5a3db1fcbbf65d3ad5acdcba822dfcf1f449ab60af"
    sha256 cellar: :any_skip_relocation, monterey:       "7b7694c86ac2c864dbd73e5a3db1fcbbf65d3ad5acdcba822dfcf1f449ab60af"
    sha256 cellar: :any_skip_relocation, big_sur:        "7b7694c86ac2c864dbd73e5a3db1fcbbf65d3ad5acdcba822dfcf1f449ab60af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3b00ff93b84d2f6df4d365644ab4e519f74fabf2f28cd1c3ab171f417fae9b30"
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
