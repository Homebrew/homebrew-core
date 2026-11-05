class Rumbledb < Formula
  desc "JSONiq and XQuery query engine on Apache Spark"
  homepage "https://rumbledb.org/"
  url "https://github.com/RumbleDB/rumble/releases/download/v3.0.5/rumbledb-3.0.5-brew.zip"
  sha256 "cac50cc7e2f3e4735e0ff6b4956cbae0e8f810dd009229333cf0a2a4f1d5796a"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8a5c8487eefaebedaa26bf9fab9f1a01ee5e3a488d810019efadadccef33d964"
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
