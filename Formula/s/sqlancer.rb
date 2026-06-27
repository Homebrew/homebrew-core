class Sqlancer < Formula
  desc "Detecting Logic Bugs in DBMS"
  homepage "https://github.com/sqlancer/sqlancer"
  url "https://github.com/sqlancer/sqlancer/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "4811fea3d08d668cd2a41086be049bdcf74c46a6bb714eb73cdf6ed19a013f41"
  license "MIT"
  head "https://github.com/sqlancer/sqlancer.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "434aa776b8e6f535368a67b42df3b0a17dcea382c06c17aaf6ea8961aa7f5aac"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "0ca4462cee4dbd7d47d818928b112489fe63c4dd0d2489bd305f9e5f172e3697"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "351350797f563ba03179e8c47f8556b5950f8ba52fa6d9eed411384405c11230"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7a8f6995c0eaf3002eead99ad6ca75a3922c7e6d4f1206a1f573fc55b2445140"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3e7fba8aa71ddb6e684ec75b414f4920a4e7f9d6cd50cbadd9952a5ae18366e8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3c92f7d690ed61405369d71a0ae3ce6cb0f5f102d3e330d20f9c2dd20831d434"
    sha256 cellar: :any_skip_relocation, sonoma:         "d53935c68d2add8d86432c2a0671cc9200105bb85a0cb39dc5949a7b1bbd0611"
    sha256 cellar: :any_skip_relocation, ventura:        "94d63909d9e75194f791872f30e80496c16ecf119f36f69f9c39c259efc9b787"
    sha256 cellar: :any_skip_relocation, monterey:       "132c2d5e369de21ea6e7e7860ca95f44d2a36c5f50325896cf170bb3e49a8d8d"
    sha256 cellar: :any_skip_relocation, big_sur:        "c355a181b18f9c30e07f98dc66b3075a56baeb775646a7b7a0417231110f49a6"
    sha256 cellar: :any_skip_relocation, catalina:       "0bd64f69b4f7f052c5c6b43ef8f5835e41aca4a2e8cd991cdcc21bd27da91e4b"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "f0eaaca38cb007dc15618d07372f00fcbfe4f794b6f8fcc6114d92c03a3053a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "afe59e6d912d3a7b055f7cc05ad72ae6f7af06b0cd208241cf0aa4a0e0506d5d"
  end

  depends_on "maven" => :build
  depends_on "openjdk"

  uses_from_macos "sqlite" => :test

  def install
    if build.head?
      inreplace "pom.xml", %r{<artifactId>sqlancer</artifactId>\n\s*<version>#{stable.version}</version>},
                             "<artifactId>sqlancer</artifactId>\n   <version>#{version}</version>"
    end
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
