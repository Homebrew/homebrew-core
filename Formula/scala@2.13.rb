class ScalaAT213 < Formula
  desc "JVM-based programming language"
  homepage "https://www.scala-lang.org/"
  url "https://downloads.lightbend.com/scala/2.13.9/scala-2.13.9.tgz"
  mirror "https://www.scala-lang.org/files/archive/scala-2.13.9.tgz"
  mirror "https://downloads.typesafe.com/scala/2.13.9/scala-2.13.9.tgz"
  sha256 "48d8ea056c288993e4b993dafcc0d4961f09ea10d0329d53e941474650ef9564"
  license "Apache-2.0"

  livecheck do
    url "https://www.scala-lang.org/files/archive/"
    regex(/href=.*?scala[._-]v?(2\.13(?:\.\d+)+)(?:[._-]final)?\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9e72814dbfe3220086b69adcac0b3c11a2a46dd8a8507d9d933433476e632ccc"
  end

  keg_only :versioned_formula

  depends_on "openjdk"

  def install
    # Replace `/usr/local` references for uniform bottles
    inreplace Dir["man/man1/scala{,c}.1"], "/usr/local", HOMEBREW_PREFIX
    rm Dir["bin/*.bat"]
    doc.install (buildpath/"doc").children
    share.install "man"
    libexec.install "lib"
    prefix.install "bin"
    bin.env_script_all_files libexec/"bin", Language::Java.overridable_java_home_env

    # Set up an IntelliJ compatible symlink farm in 'idea'
    idea = prefix/"idea"
    idea.install_symlink libexec/"lib"
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
