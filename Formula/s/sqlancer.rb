class Sqlancer < Formula
  desc "Detecting Logic Bugs in DBMS"
  homepage "https://github.com/sqlancer/sqlancer"
  url "https://github.com/sqlancer/sqlancer/archive/v2.0.0.tar.gz"
  sha256 "4811fea3d08d668cd2a41086be049bdcf74c46a6bb714eb73cdf6ed19a013f41"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7a8f6995c0eaf3002eead99ad6ca75a3922c7e6d4f1206a1f573fc55b2445140"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3e7fba8aa71ddb6e684ec75b414f4920a4e7f9d6cd50cbadd9952a5ae18366e8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3c92f7d690ed61405369d71a0ae3ce6cb0f5f102d3e330d20f9c2dd20831d434"
    sha256 cellar: :any_skip_relocation, ventura:        "94d63909d9e75194f791872f30e80496c16ecf119f36f69f9c39c259efc9b787"
    sha256 cellar: :any_skip_relocation, monterey:       "132c2d5e369de21ea6e7e7860ca95f44d2a36c5f50325896cf170bb3e49a8d8d"
    sha256 cellar: :any_skip_relocation, big_sur:        "c355a181b18f9c30e07f98dc66b3075a56baeb775646a7b7a0417231110f49a6"
    sha256 cellar: :any_skip_relocation, catalina:       "0bd64f69b4f7f052c5c6b43ef8f5835e41aca4a2e8cd991cdcc21bd27da91e4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "afe59e6d912d3a7b055f7cc05ad72ae6f7af06b0cd208241cf0aa4a0e0506d5d"
  end

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
