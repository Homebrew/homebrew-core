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
    sha256 cellar: :any_skip_relocation, all: "00eb4659648843568975043444ad9ff90cc5ce27bb1a74c81ef9120e877d277a"
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
  end
end
