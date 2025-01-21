class Textidote < Formula
  desc "Spelling, grammar and style checking on LaTeX documents"
  homepage "https://sylvainhalle.github.io/textidote"
  url "https://github.com/sylvainhalle/textidote/archive/refs/tags/v0.8.3.tar.gz"
  sha256 "8c55d6f6f35d51fb5b84e7dcc86a4041e06b3f92d6a919023dc332ba2effd584"
  license "GPL-3.0-or-later"
  head "https://github.com/sylvainhalle/textidote.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "51461cd926b6329d791237ea255458e237710fc6c5eaa0a3067b9bfde03bf533"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0286fceacded8ff1661117098ea3e864f3e6a9f8d42ba2418eb027578865f5f3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e9a83218eb82f98e70fba9d90886ddedc8402f9a664c5578ccb768f013efcee2"
    sha256 cellar: :any_skip_relocation, sonoma:        "936cca1b103e05e9301cb9442078d417f13169f9726d85e46ba0fe984ece5bd6"
    sha256 cellar: :any_skip_relocation, ventura:       "2ca10fe4b0d6c75985e19fdfe409db7aa3780bc027f1686d65dbcf295d107862"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "53bc512af1d05084aef085e8185b29444e3a9a92f515859e06cf7d9860490b31"
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

    bash_completion.install "Completions/textidote.bash" => "textidote"
    zsh_completion.install "Completions/textidote.zsh" => "_textidote"
  end

  test do
    output = shell_output("#{bin}/textidote --version")
    assert_match "TeXtidote", output

    (testpath/"test1.tex").write <<~'TEX'
      \documentclass{article}
      \begin{document}
        This should fails.
      \end{document}
    TEX

    output = shell_output("#{bin}/textidote --check en #{testpath}/test1.tex", 1)
    assert_match "The modal verb 'should' requires the verb's base form..", output

    (testpath/"test2.tex").write <<~'TEX'
      \documentclass{article}
      \begin{document}
        This should work.
      \end{document}
    TEX

    output = shell_output("#{bin}/textidote --check en #{testpath}/test2.tex")
    assert_match "Everything is OK!", output
  end
end
