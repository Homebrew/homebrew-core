class Scala < Formula
  desc "JVM-based programming language"
  homepage "https://www.scala-lang.org/"
  url "https://downloads.lightbend.com/scala/2.12.0/scala-2.12.0.tgz"
  mirror "http://www.scala-lang.org/files/archive/scala-2.12.0.tgz"
  sha256 "d4f485b3f05bbf1224ed5db34d5a5322ce8d1676236757a6cfbf4a11ac59ca22"

  bottle do
    cellar :any_skip_relocation
    sha256 "39b0710925d388a1a5f61453702c8d4816525c21a7369b120f46c72decf0eeed" => :sierra
    sha256 "05a10bbcce35c526dba3b475bc53ad076b7b1bb5088751eec7a962f718274308" => :el_capitan
    sha256 "2da6cd4894a9291c2fb0a341cc84f96522291d76644e35c9f00cf710eb6cb417" => :yosemite
    sha256 "ddd6e527a6e93c326d761c61d9811648c1eba82044ef24ded32837fa37581c16" => :mavericks
  end

  option "with-docs", "Also install library documentation"
  option "with-src", "Also install sources for IDE support"

  depends_on :java => "1.8+"

  resource "docs" do
    url "https://downloads.lightbend.com/scala/2.12.0/scala-docs-2.12.0.txz"
    mirror "http://www.scala-lang.org/files/archive/scala-docs-2.12.0.txz"
    sha256 "52e57918e7090c47354fbc11067c7a50a5c075dbfba6b297fd25f3ac606c4728"
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
