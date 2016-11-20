class Scala < Formula
  desc "JVM-based programming language"
  homepage "https://www.scala-lang.org/"
  url "https://downloads.lightbend.com/scala/2.12.0/scala-2.12.0.tgz"
  mirror "https://downloads.typesafe.com/scala/2.12.0/scala-2.12.0.tgz"
  mirror "http://www.scala-lang.org/files/archive/scala-2.12.0.tgz"
  sha256 "42be98ff9754518fd5c9a942c94ffba2464667a5e95ed4917e4e95565c96bdfe"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "2021f0815655cd419fa5ef3fec5f57b6181943ec57af8a1bee68976f2872d942" => :sierra
    sha256 "2021f0815655cd419fa5ef3fec5f57b6181943ec57af8a1bee68976f2872d942" => :el_capitan
    sha256 "2021f0815655cd419fa5ef3fec5f57b6181943ec57af8a1bee68976f2872d942" => :yosemite
  end

  option "with-docs", "Also install library documentation"
  option "with-src", "Also install sources for IDE support"

  depends_on :java => "1.8+"

  resource "docs" do
    url "https://downloads.lightbend.com/scala/2.12.0/scala-docs-2.12.0.txz"
    mirror "http://www.scala-lang.org/files/archive/scala-docs-2.12.0.txz"
    sha256 "4cb52f403339f961025de266adfaf75b5d4c15133bf0241f1e8ac058a6afc4c5"
  end

  resource "src" do
    url "https://github.com/scala/scala/archive/v2.12.0.tar.gz"
    sha256 "692c66a898e7a658303664a6cb08c2ab3626ca26324197ac7df1b0db82275564"
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

  def caveats; <<-EOS.undent
    To use with IntelliJ, set the Scala home to:
      #{opt_prefix}/idea
    EOS
  end

  test do
    file = testpath/"Test.scala"
    file.write <<-EOS.undent
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
