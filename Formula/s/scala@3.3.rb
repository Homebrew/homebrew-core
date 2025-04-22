class ScalaAT33 < Formula
  desc "JVM-based programming language"
  homepage "https://www.scala-lang.org/"
  url "https://github.com/lampepfl/dotty/releases/download/3.3.5/scala3-3.3.5.tar.gz"
  sha256 "255406d7a2f4ff745b6a125cf850f3ea96b34f26f9be7c6a3f8dbbda5d136a52"
  license "Apache-2.0"

  livecheck do
    url "https://www.scala-lang.org/download/"
    regex(%r{href=.*?download/v?(3\.3(?:\.\d+)+)\.html}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1a2e4b2b9fdb9230c5edc96c299874d294aa1bef01c2bc959c5f78d14b2b6866"
  end

  keg_only :versioned_formula

  depends_on "openjdk"

  def install
    rm Dir["bin/*.bat"]
    libexec.install "lib"
    prefix.install "bin"
    bin.env_script_all_files libexec/"bin", Language::Java.overridable_java_home_env

    # Set up an IntelliJ compatible symlink farm in 'idea'
    idea = prefix/"idea"
    idea.install_symlink libexec/"lib"
  end

  def caveats
    <<~EOS
      To use with IntelliJ, set the Scala home to:
        #{opt_prefix}/idea
    EOS
  end

  test do
    file = testpath/"Test.scala"
    file.write <<~SCALA
      object Test {
        def main(args: Array[String]): Unit = {
          println(s"${2 + 2}")
        }
      }
    SCALA

    out = shell_output("#{bin}/scala #{file}").strip

    assert_equal "4", out
  end
end
