class Yamlfmt < Formula
  desc "Extensible command-line tool to format YAML files"
  homepage "https://github.com/google/yamlfmt"
  url "https://github.com/google/yamlfmt/archive/refs/tags/v0.21.0.tar.gz"
  sha256 "9ec915d70e527a94171eaaf6b785d1423222b5b82e7633f80dcc6b66e6a655aa"
  license "Apache-2.0"
  head "https://github.com/google/yamlfmt.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d130cd939f97acb4d01154997975c541fe38e0c801a26283344f60a516d31f0a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d130cd939f97acb4d01154997975c541fe38e0c801a26283344f60a516d31f0a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d130cd939f97acb4d01154997975c541fe38e0c801a26283344f60a516d31f0a"
    sha256 cellar: :any_skip_relocation, sonoma:        "f066b093a88f1afdd40c65ebe38de012628cd9e468e8e6e93cf95bfba44776d8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9b6b0ad3837a33eb42d691e52ef981d1ac73fc3c66ff6da1d477257df50f357b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8548b4bce696dd3b3ec9abd1a0adbf007b75bfa28f86c287a963d4997f2dfda9"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/yamlfmt"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/yamlfmt -version")

    (testpath/"test.yml").write <<~YAML
      foo: bar
    YAML
    system bin/"yamlfmt", "-lint", "test.yml"
  end
end
