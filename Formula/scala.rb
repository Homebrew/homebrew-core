class Scala < Formula
  desc "JVM-based programming language"
  homepage "https://www.scala-lang.org/"
  url "https://downloads.lightbend.com/scala/2.12.2/scala-2.12.2.tgz"
  mirror "https://downloads.typesafe.com/scala/2.12.2/scala-2.12.2.tgz"
  mirror "https://www.scala-lang.org/files/archive/scala-2.12.2.tgz"
  sha256 "196168b246fcf10e275491c5e58a50ca9eb696da95e49155b3f86f001346a6f5"

  bottle do
    cellar :any_skip_relocation
    sha256 "78585de9189392bf4b8aba6693ad089754c1e53256e8ad4b84a95e86c5b025e7" => :sierra
    sha256 "fe102152679625ec1164bb9d27b961dfbdd413a5a50c451a5cb676919eca1ecc" => :el_capitan
    sha256 "fe102152679625ec1164bb9d27b961dfbdd413a5a50c451a5cb676919eca1ecc" => :yosemite
  end

  option "with-docs", "Also install library documentation"
  option "with-src", "Also install sources for IDE support"

  depends_on :java => "1.8+"

  resource "docs" do
    url "https://downloads.lightbend.com/scala/2.12.2/scala-docs-2.12.2.txz"
    mirror "https://www.scala-lang.org/files/archive/scala-docs-2.12.2.txz"
    sha256 "b64ac34aac4d61c8925ec51fcedc13438aa2ad8d49afa25d46ba4a1d0bb87f6c"
  end

  resource "src" do
    url "https://github.com/scala/scala/archive/v2.12.2.tar.gz"
    sha256 "822ef9c8077765cf558c1bbc88e957ccae77402ca02f432053f4f3bf4f91a2b1"
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
