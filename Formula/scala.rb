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
    url "https://downloads.lightbend.com/scala/2.13.0-M3/scala-2.13.0-M3.tgz"
    mirror "https://www.scala-lang.org/files/archive/scala-2.13.0-M3.tgz"
    mirror "https://downloads.typesafe.com/scala/2.13.0-M3/scala-2.13.0-M3.tgz"
    version "2.13.0-M3"
    sha256 "089a00b17edda24891c2920c2e7346a964fc13a1916ca0418bb6591da636396e"

    depends_on :java => "1.8+"

    resource "docs" do
      url "https://downloads.lightbend.com/scala/2.13.0-M3/scala-docs-2.13.0-M3.txz"
      mirror "https://www.scala-lang.org/files/archive/scala-docs-2.13.0-M3.txz"
      mirror "https://downloads.typesafe.com/scala/2.13.0-M3/scala-docs-2.13.0-M3.txz"
      version "2.13.0-M3"
      sha256 "c600cf90b3fd799ed7249377dac29c2ddab5041b95d263c9c95c15fc3756c6e6"
    end

    resource "src" do
      url "https://github.com/scala/scala/archive/v2.13.0-M3.tar.gz"
      version "2.13.0-M3"
      sha256 "93bc002ac51b02d3f41916d74c2e3c1543d3f092a95117ef50e909fc79e122e8"
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
