class Yamlfmt < Formula
  desc "Extensible command-line tool to format YAML files"
  homepage "https://github.com/google/yamlfmt"
  url "https://github.com/google/yamlfmt/archive/refs/tags/v0.17.0.tar.gz"
  sha256 "81a7f696332cc496b8bad40e03ddd98bbd26354b6745a3ef2d186e376891012c"
  license "Apache-2.0"
  head "https://github.com/google/yamlfmt.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d1faa679b50521880ed55505aed324e40f708da0eba355f6159d5d31f5112b50"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d1faa679b50521880ed55505aed324e40f708da0eba355f6159d5d31f5112b50"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d1faa679b50521880ed55505aed324e40f708da0eba355f6159d5d31f5112b50"
    sha256 cellar: :any_skip_relocation, sonoma:        "60c0b0141ff0c6f5f23d1f997b147e4df2adfc38f9f4954382ef504c226491d6"
    sha256 cellar: :any_skip_relocation, ventura:       "60c0b0141ff0c6f5f23d1f997b147e4df2adfc38f9f4954382ef504c226491d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ad00144302b5bdf0194fa932dcbac8a81138f58f483f2e112abd6baa55aeb53e"
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
