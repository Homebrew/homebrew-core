class Sbt < Formula
  desc "Build tool for Scala projects"
  homepage "https://www.scala-sbt.org/"
  url "https://github.com/sbt/sbt/releases/download/v1.9.3/sbt-1.9.3.tgz"
  mirror "https://sbt-downloads.cdnedge.bluemix.net/releases/v1.9.3/sbt-1.9.3.tgz"
  sha256 "9ccf944eccb33c66830ef9ff9d46c3402741cdc6d883251045261db33e748e82"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "75de7534a6fc431cc71af754c5877351f3cc73a6c32106c7db015f974b98a4ea"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "75de7534a6fc431cc71af754c5877351f3cc73a6c32106c7db015f974b98a4ea"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "75de7534a6fc431cc71af754c5877351f3cc73a6c32106c7db015f974b98a4ea"
    sha256 cellar: :any_skip_relocation, ventura:        "75de7534a6fc431cc71af754c5877351f3cc73a6c32106c7db015f974b98a4ea"
    sha256 cellar: :any_skip_relocation, monterey:       "75de7534a6fc431cc71af754c5877351f3cc73a6c32106c7db015f974b98a4ea"
    sha256 cellar: :any_skip_relocation, big_sur:        "75de7534a6fc431cc71af754c5877351f3cc73a6c32106c7db015f974b98a4ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9d213c5364b6bdda19e51e70030e90657ffdad0f6c4c2bd033066699bdcdd212"
  end

  depends_on "openjdk"

  def install
    inreplace "bin/sbt" do |s|
      s.gsub! 'etc_sbt_opts_file="/etc/sbt/sbtopts"', "etc_sbt_opts_file=\"#{etc}/sbtopts\""
      s.gsub! "/etc/sbt/sbtopts", "#{etc}/sbtopts"
    end

    libexec.install "bin"
    etc.install "conf/sbtopts"

    # Removes:
    # 1. `sbt.bat` (Windows-only)
    # 2. `sbtn` (pre-compiled native binary)
    (libexec/"bin").glob("sbt{.bat,n-x86_64*,n-aarch64*}").map(&:unlink)
    (bin/"sbt").write_env_script libexec/"bin/sbt", Language::Java.overridable_java_home_env
  end

  def caveats
    <<~EOS
      You can use $SBT_OPTS to pass additional JVM options to sbt.
      Project specific options should be placed in .sbtopts in the root of your project.
      Global settings should be placed in #{etc}/sbtopts

      The installation does not include `sbtn`.
    EOS
  end

  test do
    ENV.append "_JAVA_OPTIONS", "-Dsbt.log.noformat=true"
    system bin/"sbt", "--sbt-create", "about"
    assert_match version.to_s, shell_output("#{bin}/sbt sbtVersion")
  end
end
