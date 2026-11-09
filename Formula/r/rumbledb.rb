class Rumbledb < Formula
  desc "JSONiq and XQuery query engine on Apache Spark"
  homepage "https://rumbledb.org/"
  url "https://github.com/RumbleDB/rumble/releases/download/v3.1.0/rumbledb-3.1.0-brew.zip"
  sha256 "254e23d98bfb10fce996d599bf2e0cb7c2a636cd6a333b87b168ccb1b93cdd7b"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c4170f03feb4049f38fa8493c01ec723bfbea79e798766932edc9fd5c3a24a32"
  end

  depends_on "apache-spark"
  depends_on "openjdk@21"

  def install
    libexec.install "jars"
    (bin/"rumbledb").write_env_script formula_opt_bin("apache-spark")/"spark-submit",
                                      libexec/"jars/rumbledb.jar",
                                      Language::Java.overridable_java_home_env("21")
  end

  test do
    (testpath/"test.query").write "1+1"
    assert_equal "2", shell_output("#{bin}/rumbledb run test.query").strip

    assert_equal "2550",
                 shell_output("#{bin}/rumbledb run -q " \
                              "'sum(for $x in parallelize(1 to 100) where $x mod 2 eq 0 return $x)'").strip
  end
end
