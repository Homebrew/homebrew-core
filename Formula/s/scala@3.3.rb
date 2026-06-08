class ScalaAT33 < Formula
  desc "JVM-based programming language"
  homepage "https://www.scala-lang.org/"
  url "https://github.com/scala/scala3/releases/download/3.3.7/scala3-3.3.7.tar.gz"
  sha256 "ece510e2398b20bc31422b7d815ac344e968ac9e71c96445db5f136cd298c4d9"
  license "Apache-2.0"

  livecheck do
    url "https://www.scala-lang.org/download/"
    regex(%r{href=.*?download/v?(3\.3(?:\.\d+)+)\.html}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "84cf0ec57b03e2a2bdac6cc375a87808b03805dfcb5fc82a8bf4bc72e6a11879"
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
