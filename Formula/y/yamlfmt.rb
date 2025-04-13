class Yamlfmt < Formula
  desc "Extensible command-line tool to format YAML files"
  homepage "https://github.com/google/yamlfmt"
  url "https://github.com/google/yamlfmt/archive/refs/tags/v0.16.0.tar.gz"
  sha256 "989d9010e2498b4f97608b1c64798c700012840e739bc9001e42ddf3f25125a2"
  license "Apache-2.0"
  head "https://github.com/google/yamlfmt.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "432bc292d0feb0e9597bd786e628e01b0557a847d303cf1e5006c5b70111041f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "432bc292d0feb0e9597bd786e628e01b0557a847d303cf1e5006c5b70111041f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "432bc292d0feb0e9597bd786e628e01b0557a847d303cf1e5006c5b70111041f"
    sha256 cellar: :any_skip_relocation, sonoma:        "899210545175b84e91bee5ae9337912ce1d6d755d462f9ec2620a2f8a722d0ff"
    sha256 cellar: :any_skip_relocation, ventura:       "899210545175b84e91bee5ae9337912ce1d6d755d462f9ec2620a2f8a722d0ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "818289e664422a8c73aea66665a680d7bfbd4e18d5b34b06e081a68cfb3478ad"
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
