class ScalaAT211 < Formula
  desc "JVM-based programming language"
  homepage "https://www.scala-lang.org/"
  url "https://downloads.lightbend.com/scala/2.11.12/scala-2.11.12.tgz"
  mirror "https://downloads.typesafe.com/scala/2.11.12/scala-2.11.12.tgz"
  mirror "https://www.scala-lang.org/files/archive/scala-2.11.12.tgz"
  sha256 "b11d7d33699ca4f60bc3b2b6858fd953e3de2b8522c943f4cda4b674316196a8"

  bottle :unneeded

  keg_only :versioned_formula

  option "with-docs", "Also install library documentation"
  option "with-src", "Also install sources for IDE support"

  depends_on :java => "1.8"

  resource "docs" do
    url "https://downloads.lightbend.com/scala/2.11.12/scala-docs-2.11.12.txz"
    mirror "https://www.scala-lang.org/files/archive/scala-docs-2.11.12.txz"
    sha256 "380f522e287308e8e61ca6ff7abfadf50525e15cd42e05fa84fae8caf07b39b3"
  end

  resource "src" do
    url "https://github.com/scala/scala/archive/v2.11.12.tar.gz"
    sha256 "b4c9268e461d165592e35f56e3ee9a1482310055f12d59f8b116c29d393d06ea"
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
    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", Language::Java.java_home_env("1.8"))
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
