class Scala < Formula
  desc "JVM-based programming language"
  homepage "https://www.scala-lang.org"
  # IllegalArgumentException: One of setGitDir or setWorkTree must be called.
  url "https://github.com/scala/scala3.git",
      tag:      "3.8.2",
      revision: "6e95f60607d251bf0483b6fb3cc07c595b49dc25"
  license "Apache-2.0"

  livecheck do
    url "https://www.scala-lang.org/download/"
    regex(%r{href=.*?download/v?(\d+(?:\.\d+)+)\.html}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d2d8ad6f10164bd6fc0b6e7077bd508a652d5723289ee1b14b8ee78faa91e0fe"
  end

  depends_on "sbt" => :build
  depends_on "openjdk"

  conflicts_with "pwntools", because: "both install `common` binaries"

  def install
    os = OS.mac? ? "mac" : "linux"
    arch = Hardware::CPU.arm? ? "aarch64" : "x86_64"

    system "sbt", "dist-#{os}-#{arch}/Universal/stage"

    cd "dist/#{os}-#{arch}/target/universal/stage" do
      rm Dir["**/*.bat"]

      libexec.install "lib", "maven2", "VERSION", "libexec"
      prefix.install "bin"
    end
    bin.env_script_all_files libexec/"bin", Language::Java.overridable_java_home_env
    (bin/"scala-cli").write_env_script libexec/"libexec/scala-cli", Language::Java.overridable_java_home_env

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
