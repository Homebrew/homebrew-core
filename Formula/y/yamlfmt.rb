class Yamlfmt < Formula
  desc "Extensible command-line tool to format YAML files"
  homepage "https://github.com/google/yamlfmt"
  url "https://github.com/google/yamlfmt/archive/refs/tags/v0.20.0.tar.gz"
  sha256 "de6bc4373ba46c520d936dd4b60395868ec17aba338b9fd849594c1f41b6c057"
  license "Apache-2.0"
  head "https://github.com/google/yamlfmt.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b14f51773eedb24ea8e469fb629ae71b1a48a7f8028a9c988281d9181ef80380"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b14f51773eedb24ea8e469fb629ae71b1a48a7f8028a9c988281d9181ef80380"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b14f51773eedb24ea8e469fb629ae71b1a48a7f8028a9c988281d9181ef80380"
    sha256 cellar: :any_skip_relocation, sonoma:        "49184c42f7a6694749b9598719c4a00f71b7f5243c4745ef804cbad35b2be2c5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "501eedb3398b4e7ea7214a70263e9ead25141ba7fe26d52ca3a9be7a7eb84a67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f07ba36a80227cbe3998f89efd76308bd3415873b491151f40d96483d9243f24"
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
