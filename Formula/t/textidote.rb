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

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3341188f4b8fb7912f78dcb53dda8f624dcc8693f96a51c1ccaa49422746b84a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3bc15a1fbb32e89fa3aa4f01a348336f1032974eca44c74789719e8e3ee9f391"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5c7874766d3f1f514f1b32435f160c92a0622a19ca8d2b0f7a8f653bfec05445"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4bf516adb25ff61f3453f6825819e6353e2045619e46c7168ee250a782dc538d"
    sha256 cellar: :any_skip_relocation, sonoma:        "39c5742e46605837bfb719356ba9aeb9811afa145ef5bdaabe0982704a270a30"
    sha256 cellar: :any_skip_relocation, ventura:       "e50f6561b290ac98eec57706a01c5a6e644a66b5d12e2c289d81c785d05f6ce4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1bf9049a7149770b7e587a8a0fd0437750306a7ab810b7f6d878aeca523a54e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "73b3a785959a0992e981b78f47a4c39932c59f158a3d4c3281fb5ccc5926abc5"
  end

  depends_on "ant" => :build
  depends_on "openjdk"

  def install
    # Build the JAR
    system "ant", "download-deps"
    system "ant", "-Dbuild.targetjdk=#{Formula["openjdk"].version.major}"

    # Install the JAR + a wrapper script
    libexec.install "textidote.jar"
    # Fix run with `openjdk` 24.
    # Reported upstream at https://github.com/sylvainhalle/textidote/issues/265.
    bin.write_jar_script libexec/"textidote.jar", "textidote", "-Djdk.xml.totalEntitySizeLimit=50000000"

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
