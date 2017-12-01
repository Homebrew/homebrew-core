class Scala < Formula
  desc "JVM-based programming language"
  homepage "https://www.scala-lang.org/"

  stable do
    url "https://downloads.lightbend.com/scala/2.12.4/scala-2.12.4.tgz"
    mirror "https://downloads.typesafe.com/scala/2.12.4/scala-2.12.4.tgz"
    mirror "https://www.scala-lang.org/files/archive/scala-2.12.4.tgz"
    sha256 "9554a0ca31aa8701863e881281b1772370a87e993ce785bb24505f2431292a21"

    depends_on :java => "1.8+"

    resource "docs" do
      url "https://downloads.lightbend.com/scala/2.12.4/scala-docs-2.12.4.txz"
      mirror "https://www.scala-lang.org/files/archive/scala-docs-2.12.4.txz"
      sha256 "477892c8bb7df996166a767037cc16feb67ec9810273fd47bf43fa1eee0597a8"
    end

    resource "src" do
      url "https://github.com/scala/scala/archive/v2.12.4.tar.gz"
      sha256 "9d1eaf570f95204a8894ab941070354b1672904a903ae3d1b45df201ddd1ed7d"
    end
  end

  devel do
    version "2.13.0-M2"
    url "https://downloads.lightbend.com/scala/2.13.0-M2/scala-2.13.0-M2.tgz"
    mirror "https://www.scala-lang.org/files/archive/scala-2.13.0-M2.tgz"
    mirror "https://downloads.typesafe.com/scala/2.13.0-M2/scala-2.13.0-M2.tgz"
    sha256 "3b83c4165d6be1854078ace552dd424acca6ddf718a908f103c206847802e808"

    depends_on :java => "1.8+"

    resource "docs" do
      url "https://downloads.lightbend.com/scala/2.13.0-M2/scala-docs-2.13.0-M2.txz"
      mirror "https://www.scala-lang.org/files/archive/scala-docs-2.13.0-M2.txz"
      mirror "https://downloads.typesafe.com/scala/2.13.0-M2/scala-docs-2.13.0-M2.txz"
      sha256 "add2e7d495aedeab0825b8214eb5782c0ab3fa4b65d2e763203d830364e9bbdc"
    end

    resource "src" do
      url "https://github.com/scala/scala/archive/v2.13.0-M2.tar.gz"
      sha256 "2a5f1b4c1fa5551e36965d0eb001d349cf1a217c1962e780cd3ae7a90e0e996a"
    end
  end

  bottle :unneeded

  option "with-docs", "Also install library documentation"
  option "with-src", "Also install sources for IDE support"

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

    out = shell_output("#{bin}/scala -nc #{file}").strip

    assert_equal "4", out
  end
end
