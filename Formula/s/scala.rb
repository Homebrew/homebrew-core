class Scala < Formula
  desc "JVM-based programming language"
  homepage "https://dotty.epfl.ch/"
  url "https://github.com/scala/scala3/releases/download/3.8.1/scala3-3.8.1.tar.gz"
  sha256 "e91754fcbdf351013bba20bb4f5abc4e9b490a83272b193ce022d743d434028f"
  license "Apache-2.0"

  livecheck do
    url "https://www.scala-lang.org/download/"
    regex(%r{href=.*?download/v?(\d+(?:\.\d+)+)\.html}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c2e235b04ddbb1ea607c69c7bd071696ea2c4491350123b95a8acdd614fadbc5"
  end

  # JDK Compatibility: https://docs.scala-lang.org/overviews/jdk-compatibility/overview.html
  depends_on "openjdk"

  conflicts_with "pwntools", because: "both install `common` binaries"

  def install
    rm Dir["bin/*.bat"]

    libexec.install "lib", "maven2", "VERSION", "libexec"
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

    out = shell_output("#{bin}/scala --server=false #{file}").strip

    assert_equal "4", out
  end
end
