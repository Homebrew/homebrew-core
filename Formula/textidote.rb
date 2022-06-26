class Textidote < Formula
  desc "Spelling, grammar and style checking on LaTeX documents"
  homepage "https://sylvainhalle.github.io/textidote"
  url "https://github.com/sylvainhalle/textidote/archive/refs/tags/v0.8.3.tar.gz"
  sha256 "8c55d6f6f35d51fb5b84e7dcc86a4041e06b3f92d6a919023dc332ba2effd584"
  license "GPL-3.0-or-later"
  head "https://github.com/sylvainhalle/textidote.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c43727c26715f20b4f584dc84f451892795aa2a0ea7acd126b8f60e3b75a7ea6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "699f0bfbe3ec8667be03c956935ded5af3eca9c22ad7a6a627a29dc40224e863"
    sha256 cellar: :any_skip_relocation, monterey:       "306ad9dd1d5cfa96ea9976fa349ec38bd0a246f0feaf27223fff86f51bcd879d"
    sha256 cellar: :any_skip_relocation, big_sur:        "62cb64ee83a30dae725475d3bb5b5260ed74784ce4b7bfe071a2cf0c7bb7a917"
    sha256 cellar: :any_skip_relocation, catalina:       "2c307c617920b39a668b3b4d877da206912f615bf409cdafa17e4a0063393171"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0571032b89ba4edb5560e4358dab877bcdd15eb8a8d76c8656405362e0da8923"
  end

  depends_on "ant" => :build
  depends_on "openjdk"

  def install
    # Build the JAR
    system "ant", "download-deps"
    system "ant", "-Dbuild.targetjdk=#{Formula["openjdk"].version.major}"

    # Install the JAR + a wrapper script
    libexec.install "textidote.jar"
    bin.write_jar_script libexec/"textidote.jar", "textidote"

    bash_completion.install "Completions/textidote.bash"
    zsh_completion.install "Completions/textidote.zsh" => "_textidote"
  end

  test do
    output = shell_output("#{bin}/textidote --version")
    assert_match "TeXtidote", output

    (testpath/"test1.tex").write <<~EOF
      \\documentclass{article}
      \\begin{document}
        This should fails.
      \\end{document}
    EOF

    output = shell_output("#{bin}/textidote --check en #{testpath}/test1.tex", 1)
    assert_match "The modal verb 'should' requires the verb's base form..", output

    (testpath/"test2.tex").write <<~EOF
      \\documentclass{article}
      \\begin{document}
        This should work.
      \\end{document}
    EOF

    output = shell_output("#{bin}/textidote --check en #{testpath}/test2.tex")
    assert_match "Everything is OK!", output
  end
end
