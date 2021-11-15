class Sqlancer < Formula
  desc "Detecting Logic Bugs in DBMS"
  homepage "https://github.com/sqlancer/sqlancer"
  url "https://github.com/sqlancer/sqlancer/archive/1.1.0.tar.gz"
  sha256 "ce36d338e7af3649256ff1af89d26ca59fee8e8965529c293ef5592e103953fc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c1ee8830cc5860081ad5d2b3f95cdf4f04a3d25a6c88eaa72f6fecf978dee27b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "92a80ca266d0c95b5030d5745a7eb3d42ea30059c07d84b42ed97160e080f744"
    sha256 cellar: :any_skip_relocation, monterey:       "f5c66ee85118871e700560eabd9cfe4a13216802943f63f5e1aaee32dabfbda0"
    sha256 cellar: :any_skip_relocation, big_sur:        "29f1b9a3d118889abcaa721e5ce5ee48a0e3205a5a6e1ca4fcd1ceef3668f7dc"
    sha256 cellar: :any_skip_relocation, catalina:       "9f37e37e733fe9afd2b70f3feadf73638fa0ac6c445172e6afcce4e51d68a530"
    sha256 cellar: :any_skip_relocation, mojave:         "a7ebed5feab8b8f95b938c24f061dd89323f7735c04da967c5fa471390acd280"
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
