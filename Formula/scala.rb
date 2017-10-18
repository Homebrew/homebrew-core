class Scala < Formula
  desc "JVM-based programming language"
  homepage "https://www.scala-lang.org/"
  url "https://downloads.lightbend.com/scala/2.12.3/scala-2.12.3.tgz"
  mirror "https://downloads.typesafe.com/scala/2.12.3/scala-2.12.3.tgz"
  mirror "https://www.scala-lang.org/files/archive/scala-2.12.3.tgz"
  sha256 "2b796ab773fbedcc734ba881a6486d54180b699ade8ba7493e91912044267c8c"

  bottle :unneeded

  option "with-docs", "Also install library documentation"
  option "with-src", "Also install sources for IDE support"

  depends_on :java => "1.8+"

  resource "docs" do
    url "https://downloads.lightbend.com/scala/2.12.3/scala-docs-2.12.3.txz"
    mirror "https://www.scala-lang.org/files/archive/scala-docs-2.12.3.txz"
    sha256 "b3b2b4d222b5dc210505b9615fdfa18711a7f44faa4ecea3be5a1c1b03d5fac0"
  end

  resource "src" do
    url "https://github.com/scala/scala/archive/v2.12.3.tar.gz"
    sha256 "09b0c51f214ec60bf0597f9d8cd22a29d2b2c4b204b1ac01cb7122f8bac95d27"
  end

  resource "completion" do
    url "https://raw.githubusercontent.com/scala/scala-tool-support/0a217bc/bash-completion/src/main/resources/completion.d/2.9.1/scala"
    sha256 "95aeba51165ce2c0e36e9bf006f2904a90031470ab8d10b456e7611413d7d3fd"
  end

  def install
    rm_f Dir["bin/*.bat"]
    doc.install Dir["doc/*"]
    share.install "man"
    libexec.install "bin", "lib"
    bin.install_symlink Dir["#{libexec}/bin/*"]
    bash_completion.install resource("completion")
    doc.install resource("docs") if build.with? "docs"
    libexec.install resource("src").files("src") if build.with? "src"

    # Set up an IntelliJ compatible symlink farm in 'idea'
    idea = prefix/"idea"
    idea.install_symlink libexec/"src", libexec/"lib"
    idea.install_symlink doc => "doc"
  end

  def caveats; <<~EOS
    To use with IntelliJ, set the Scala home to:
      #{opt_prefix}/idea
    EOS
  end

  test do
    file = testpath/"Test.scala"
    file.write <<~EOS
      object Test {
        def main(args: Array[String]) {
          println(s"${2 + 2}")
        }
      }
    EOS

    out = shell_output("#{bin}/scala #{file}").strip
    # Shut down the compile server so as not to break Travis
    system bin/"fsc", "-shutdown"

    assert_equal "4", out
  end
end
