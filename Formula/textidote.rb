class Textidote < Formula
  desc "Spelling, grammar and style checking on LaTeX documents"
  homepage "https://sylvainhalle.github.io/textidote"
  url "https://github.com/sylvainhalle/textidote/archive/refs/tags/v0.8.3.tar.gz"
  sha256 "8c55d6f6f35d51fb5b84e7dcc86a4041e06b3f92d6a919023dc332ba2effd584"
  license "GPL-3.0-only"
  head "https://github.com/sylvainhalle/textidote.git", branch: "master"

  depends_on "ant" => :build
  depends_on "openjdk"

  def install
    # Build the JAR
    system "ant", "download-deps"
    system "ant", "-Dbuild.targetjdk=1.7"

    # Install the JAR + a wrapper script
    libexec.mkpath
    libexec.install "textidote.jar"
    bin.mkpath
    bin.write_jar_script libexec/"textidote.jar", "textidote"

    # Install the completions script
    bash_completion.mkpath
    bash_completion.install "Completions/textidote.bash"
    zsh_completion.mkpath
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

    # Use `--ci`, otherwise TeXtidote returns the number of warnings as the return code.
    output = shell_output("#{bin}/textidote --check en --ci #{testpath}/test1.tex")
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
