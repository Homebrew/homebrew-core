class Scala < Formula
  desc "JVM-based programming language"
  homepage "https://www.scala-lang.org/"
  url "https://downloads.lightbend.com/scala/2.12.7/scala-2.12.7.tgz"
  mirror "https://www.scala-lang.org/files/archive/scala-2.12.7.tgz"
  mirror "https://downloads.typesafe.com/scala/2.12.7/scala-2.12.7.tgz"
  sha256 "d65b0db501287a0fed5a78d92c37cc558af52d9b5339e74f5dd6c71fb736d184"

  bottle :unneeded

  option "with-docs", "Also install library documentation"
  option "with-src", "Also install sources for IDE support"

  depends_on :java => "1.8+"

  resource "docs" do
    url "https://downloads.lightbend.com/scala/2.12.7/scala-docs-2.12.7.txz"
    mirror "https://www.scala-lang.org/files/archive/scala-docs-2.12.7.txz"
    mirror "https://downloads.typesafe.com/scala/2.12.7/scala-docs-2.12.7.txz"
    sha256 "62ccdae8995ec29dc9b26368d8a8d3e6bb8e7c3e1a12823ef88bc66f4402bb7d"
  end

  resource "src" do
    url "https://github.com/scala/scala/archive/v2.12.7.tar.gz"
    sha256 "66e2238ad55c959041e59cf4fb782bc3011f5f07b2c724f491ad38c0b73c4ed4"
  end

  resource "completion" do
    url "https://raw.githubusercontent.com/scala/scala-tool-support/0a217bc446b970116c67c933a747d5f57b853d34/bash-completion/src/main/resources/completion.d/2.9.1/scala"
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
