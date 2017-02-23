class ScalaAT211 < Formula
  desc "JVM-based programming language"
  homepage "https://www.scala-lang.org/"
  url "https://downloads.lightbend.com/scala/2.11.8/scala-2.11.8.tgz"
  mirror "https://downloads.typesafe.com/scala/2.10.6/scala-2.11.8.tgz"
  mirror "https://www.scala-lang.org/files/archive/scala-2.11.8.tgz"
  sha256 "87fc86a19d9725edb5fd9866c5ee9424cdb2cd86b767f1bb7d47313e8e391ace"

  option "with-docs", "Also install library documentation"
  option "with-src", "Also install sources for IDE support"

  depends_on :java => "1.6+"

  conflicts_with "scala", :because => "Differing version of same formula"
  conflicts_with "scala@2.10", :because => "Differing version of same formula"

  resource "docs" do
    url "https://downloads.lightbend.com/scala/2.11.8/scala-docs-2.11.8.txz"
    mirror "https://www.scala-lang.org/files/archive/scala-docs-2.11.8.txz"
    sha256 "f79180418c9a4827306c2e30d8de451d29daf72ec441e023ae73d25b39b3c0db"
  end

  resource "src" do
    url "https://github.com/scala/scala/archive/v2.11.8.tar.gz"
    sha256 "4f11273b4b3c771019253b2c09102245d063a7abeb65c7b1c4519bd57605edcf"
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
