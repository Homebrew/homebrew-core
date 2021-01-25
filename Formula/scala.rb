class Scala < Formula
  desc "JVM-based programming language"
  homepage "https://www.scala-lang.org/"
  url "https://downloads.lightbend.com/scala/2.13.4/scala-2.13.4.tgz"
  mirror "https://www.scala-lang.org/files/archive/scala-2.13.4.tgz"
  mirror "https://downloads.typesafe.com/scala/2.13.4/scala-2.13.4.tgz"
  sha256 "bc711cfba58fcad772de2719f13ac06415fe43f2d323ffb6b600a8d7ebb78caa"
  license "Apache-2.0"

  livecheck do
    url "https://www.scala-lang.org/files/archive"
    regex(/href=.*?scala[._-]v?(\d+(?:\.\d+)+)(?:.final)?\.t/i)
  end

  bottle :unneeded

  depends_on "openjdk"

  def install
    rm_f Dir["bin/*.bat"]
    doc.install Dir["doc/*"]
    share.install "man"
    libexec.install "bin", "lib"
    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files libexec/"bin", Language::Java.overridable_java_home_env

    # Set up an IntelliJ compatible symlink farm in 'idea'
    idea = prefix/"idea"
    idea.install_symlink libexec/"src", libexec/"lib"
    idea.install_symlink doc => "doc"
  end

  def caveats
    <<~EOS
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
