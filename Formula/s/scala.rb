class Scala < Formula
  desc "JVM-based programming language"
  homepage "https://scala-lang.org/"
  url "https://github.com/scala/scala3/releases/download/3.8.3/scala3-3.8.3.tar.gz"
  sha256 "ff62e827eb1ea17813d97e5fd5e0d2690110787173fe1e1e43d9dadcc3542fa7"
  license "Apache-2.0"

  livecheck do
    url "https://www.scala-lang.org/download/"
    regex(%r{href=.*?download/v?(\d+(?:\.\d+)+)\.html}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9c0aa8286ed3acd4d7e20a953806c5d794bb662f74131b4c8a14046be0ff5340"
  end

  # JDK Compatibility: https://docs.scala-lang.org/overviews/jdk-compatibility/overview.html
  depends_on "openjdk@17"
  depends_on "scala-cli"

  def install
    rm Dir["bin/*.bat"]
    rm Dir["libexec/*.bat"]

    libexec.install "lib", "maven2", "VERSION"
    (libexec/"libexec").install "libexec/common", "libexec/common-shared", "libexec/cli-common-platform"

    inreplace libexec/"libexec/cli-common-platform",
              /SCALA_CLI_CMD_BASH=.*/,
              "SCALA_CLI_CMD_BASH=(\"#{Formula["scala-cli"].opt_bin}/scala-cli\")"

    bin.install "bin/scala", "bin/scalac", "bin/scaladoc"
    bin.env_script_all_files libexec/"bin", Language::Java.overridable_java_home_env("17")

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
