class Scala < Formula
  desc "JVM-based programming language"
  homepage "https://scala-lang.org/"
  url "https://github.com/scala/scala3/releases/download/3.8.4/scala3-3.8.4.tar.gz"
  sha256 "cb2f9a358ec449eec417d63efd9b6fc6bd66a13b1347d49c25571eca284857d3"
  license "Apache-2.0"

  livecheck do
    url "https://www.scala-lang.org/download/"
    regex(%r{href=.*?download/v?(\d+(?:\.\d+)+)\.html}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f6352ce0295d17f6bea6cde7a45e00e33c0d8967cd81302de861f783b3f7015c"
  end

  # JDK Compatibility: https://docs.scala-lang.org/overviews/jdk-compatibility/overview.html
  depends_on "openjdk"
  depends_on "scala-cli"

  def install
    rm Dir["bin/*.bat"]
    rm Dir["libexec/*.bat"]

    libexec.install "lib", "maven2", "VERSION"
    (libexec/"libexec").install "libexec/common", "libexec/common-shared", "libexec/cli-common-platform"

    inreplace libexec/"libexec/cli-common-platform",
              /SCALA_CLI_CMD_BASH=.*/,
              "SCALA_CLI_CMD_BASH=(\"#{formula_opt_bin("scala-cli")}/scala-cli\")"

    bin.install "bin/scala", "bin/scalac", "bin/scaladoc"
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
    ENV["SCALA_CLI_HOME"] = testpath
    ENV["COURSIER_CACHE"] = ENV["COURSIER_ARCHIVE_CACHE"] = testpath/".coursier_cache"

    %w[scala scalac scaladoc].each do |cmd|
      assert_match version.to_s, shell_output("#{bin}/#{cmd} --version")
    end

    file = testpath/"Test.scala"
    file.write <<~SCALA
      object Test {
        def main(args: Array[String]): Unit = {
          println(s"${2 + 2}")
        }
      }
    SCALA

    out = shell_output("#{bin}/scala --server=false #{file}").chomp
    assert_equal "4", out
  end
end
