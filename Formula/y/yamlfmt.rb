class Yamlfmt < Formula
  desc "Extensible command-line tool to format YAML files"
  homepage "https://github.com/google/yamlfmt"
  url "https://github.com/google/yamlfmt/archive/refs/tags/v0.15.0.tar.gz"
  sha256 "e1c0461ece664516ddcb51a513e7cc4c955fe4e08f6d3193396bcffd16b9f798"
  license "Apache-2.0"
  head "https://github.com/google/yamlfmt.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2343005d1b1df4aa279d819c1aff8d28a3a13046e8a16a91d0528aaaf9022041"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2343005d1b1df4aa279d819c1aff8d28a3a13046e8a16a91d0528aaaf9022041"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2343005d1b1df4aa279d819c1aff8d28a3a13046e8a16a91d0528aaaf9022041"
    sha256 cellar: :any_skip_relocation, sonoma:        "cfa25baa8706007c5403efc39836074f54b5fb8878547299af7cde2561a8f808"
    sha256 cellar: :any_skip_relocation, ventura:       "cfa25baa8706007c5403efc39836074f54b5fb8878547299af7cde2561a8f808"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dfd5debc8b0e9a2a45e43b802ba41921a8c62b3a9bf178caa80c72cfa7c82b6c"
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
