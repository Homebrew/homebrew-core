class Rumbledb < Formula
  desc "JSONiq and XQuery query engine on Apache Spark"
  homepage "https://rumbledb.org/"
  url "https://github.com/RumbleDB/rumble/releases/download/v2.1.0/rumbledb-2.1.0-brew.zip"
  sha256 "250b9a79e6fed34c595f75bb60d786b366e335c361169d1447538442fd32f29b"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c3461f8f7ecc1a25a2d3c4036be2f21613dce95f08c8111a15618395e7ee4e42"
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
    assert_match version.to_s, shell_output("#{bin}/rumbledb repl < /dev/null 2>&1")
    assert_equal "2", shell_output("#{bin}/rumbledb -q '1+1'").strip
  end
end
