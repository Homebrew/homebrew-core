class Scala < Formula
  desc "JVM-based programming language"
  homepage "https://www.scala-lang.org/"
  url "https://downloads.lightbend.com/scala/2.13.1/scala-2.13.1.tgz"
  mirror "https://www.scala-lang.org/files/archive/scala-2.13.1.tgz"
  mirror "https://downloads.typesafe.com/scala/2.13.1/scala-2.13.1.tgz"
  sha256 "6918ccc494e34810a7254ad2c4e6f0e1183784c22e7b4801b7dbc8d1994a04db"

  bottle :unneeded

  depends_on :java => "1.8+"

  def install
    rm_f Dir["bin/*.bat"]
    doc.install Dir["doc/*"]
    share.install "man"
    libexec.install "bin", "lib"
    bin.install_symlink Dir["#{libexec}/bin/*"]

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
        def main(args: Array[String]): Unit = {
          println(s"${2 + 2}")
        }
      }
    EOS

    out = shell_output("#{bin}/scala #{file}").strip

    assert_equal "4", out
  end
end
