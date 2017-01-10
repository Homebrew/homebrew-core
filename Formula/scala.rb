class Scala < Formula
  desc "JVM-based programming language"
  homepage "https://www.scala-lang.org/"
  url "https://downloads.lightbend.com/scala/2.12.1/scala-2.12.1.tgz"
  mirror "https://downloads.typesafe.com/scala/2.12.1/scala-2.12.1.tgz"
  mirror "http://www.scala-lang.org/files/archive/scala-2.12.1.tgz"
  sha256 "4db068884532a3e27010df17befaca0f06ea50f69433d58e06a5e63c7a3cc359"

  bottle do
    cellar :any_skip_relocation
    sha256 "db41ce1c81a4275a4995e63c21e5fe656d33f5373860cbe4417b771646355850" => :sierra
    sha256 "db41ce1c81a4275a4995e63c21e5fe656d33f5373860cbe4417b771646355850" => :el_capitan
    sha256 "db41ce1c81a4275a4995e63c21e5fe656d33f5373860cbe4417b771646355850" => :yosemite
  end

  option "with-docs", "Also install library documentation"
  option "with-src", "Also install sources for IDE support"

  depends_on :java => "1.8+"

  resource "docs" do
    url "https://downloads.lightbend.com/scala/2.12.1/scala-docs-2.12.1.txz"
    mirror "http://www.scala-lang.org/files/archive/scala-docs-2.12.1.txz"
    sha256 "b8730008ab64cddb0cfaebae61396147461a5a1a75258640b92033b7e2661e4d"
  end

  resource "src" do
    url "https://github.com/scala/scala/archive/v2.12.1.tar.gz"
    sha256 "edff94803a632139c132d23b103e0482317d3ecf1c745721501365b28eb02c90"
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
