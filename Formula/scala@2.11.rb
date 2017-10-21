class ScalaAT211 < Formula
  desc "JVM-based programming language"
  homepage "https://www.scala-lang.org/"
  url "https://downloads.lightbend.com/scala/2.11.11/scala-2.11.11.tgz"
  mirror "https://downloads.typesafe.com/scala/2.11.11/scala-2.11.11.tgz"
  mirror "https://www.scala-lang.org/files/archive/scala-2.11.11.tgz"
  sha256 "12037ca64c68468e717e950f47fc77d5ceae5e74e3bdca56f6d02fd5bfd6900b"

  bottle :unneeded

  keg_only :versioned_formula

  option "with-docs", "Also install library documentation"
  option "with-src", "Also install sources for IDE support"

  depends_on :java => "1.6+"

  resource "docs" do
    url "https://downloads.lightbend.com/scala/2.11.11/scala-docs-2.11.11.txz"
    mirror "https://www.scala-lang.org/files/archive/scala-docs-2.11.11.txz"
    sha256 "14f1db4764286b7f4c2a1237fd6a650dac352b44ffb6811505af5e703053b362"
  end

  resource "src" do
    url "https://github.com/scala/scala/archive/v2.11.11.tar.gz"
    sha256 "f97bccddbc53fc4da027fda3d2e6ad3d7776ec7ce56adad0ddb505266e1689e1"
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
