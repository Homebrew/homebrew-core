class Sqlancer < Formula
  desc "Detecting Logic Bugs in DBMS"
  homepage "https://github.com/sqlancer/sqlancer"
  url "https://github.com/sqlancer/sqlancer/archive/1.1.0.tar.gz"
  sha256 "ce36d338e7af3649256ff1af89d26ca59fee8e8965529c293ef5592e103953fc"
  license "MIT"

  depends_on "maven" => :build
  depends_on "openjdk"

  uses_from_macos "sqlite" => :test

  def install
    system "mvn", "package", "-DskipTests=true",
                             "-Dmaven.javadoc.skip=true",
                             "-Djacoco.skip=true"
    libexec.install "target"
    bin.write_jar_script libexec/"target/sqlancer-#{version}.jar", "sqlancer"
  end

  test do
    cmd = %w[
      sqlancer
      --print-progress-summary true
      --num-threads 1
      --timeout-seconds 5
      --random-seed 1
      sqlite3
    ].join(" ")
    output = shell_output(cmd)

    assert_match(/Overall execution statistics/, output)
    assert_match(/\d+k? successfully-executed statements/, output)
    assert_match(/\d+k? unsuccessfuly-executed statements/, output)
  end
end
