class ScalaAT213 < Formula
  desc "JVM-based programming language"
  homepage "https://www.scala-lang.org/"
  url "https://downloads.lightbend.com/scala/2.13.16/scala-2.13.16.tgz"
  mirror "https://www.scala-lang.org/files/archive/scala-2.13.16.tgz"
  mirror "https://downloads.typesafe.com/scala/2.13.16/scala-2.13.16.tgz"
  sha256 "937f743be315302caad15be99ab1ca425ff7e63f15ef5790db6c81bb49543256"
  license "Apache-2.0"

  livecheck do
    url "https://www.scala-lang.org/files/archive/"
    regex(/href=.*?scala[._-]v?(2\.13(?:\.\d+)+)(?:[._-]final)?\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7095101fa3ff5a8bef712c14a3fde138274e2765afb17b33d447a0e4eb33c966"
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
