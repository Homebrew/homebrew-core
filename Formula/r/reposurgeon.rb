class Reposurgeon < Formula
  desc "Edit version-control repository history"
  homepage "http://www.catb.org/esr/reposurgeon/"
  url "https://gitlab.com/esr/reposurgeon/-/archive/5.12/reposurgeon-5.12.tar.gz"
  sha256 "e9a6cce233e8f01e2b30882b7d6cc7aefd0d6683ab51b92e6bac582be36a8859"
  license "BSD-2-Clause"
  head "https://gitlab.com/esr/reposurgeon.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7e25c4ad5a8243a515843881bbfb999dc44eb5251eab12f5ed68d6ae359ee481"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "853a13c4063f954df4aa9f56ac94bcd0096840b8f86d9746771e1a375fe17bf2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a77759a15d1798f603fb64dc4938406bb0136f037bcd11cefa6d3f825bb4044d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "85b762bbc886ad77564456037435492d7387a7ce81cd9379bfe55326b48403ed"
    sha256 cellar: :any,                 x86_64_linux:      "7f714f7ab669ac1aabe7a22d9ed4c56b27f3560677836ace0560c8dd9a5d7e0d"
  end

  depends_on "asciidoctor" => :build
  depends_on "go" => :build
  depends_on "ruby" => :build # same Ruby as asciidoctor

  on_linux do
    depends_on "gawk" => :build
  end

  def install
    ENV.append_path "GEM_PATH", formula_opt_libexec("asciidoctor")
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
    elisp.install "reposurgeon-mode.el"
  end

  test do
    system "git", "init"
    system "git", "commit", "--allow-empty", "--message", "brewing"

    assert_match "brewing",
      shell_output("#{bin}/reposurgeon read list")
  end
end
