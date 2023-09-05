class Yamlfmt < Formula
  desc "Extensible command-line tool to format YAML files"
  homepage "https://github.com/google/yamlfmt"
  url "https://github.com/google/yamlfmt/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "27d3528a835548b820cd68b3ee60fe5bbed6562a8d54848e353fb19bb7f7f188"
  license "Apache-2.0"
  head "https://github.com/google/yamlfmt.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "19158d063dadfb16fee2a6ef1f008351daffd775a044fbcc10a71da878a2b3ca"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "33e0efa7383d2a3448237c48a0c01ac43d6caf760508ccd1bf1de4fcb4bd267b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "72e23f2ae3f2c0ba811ac4b2b85d05d7ea863cddf0acc464d21d00a83b88efac"
    sha256 cellar: :any_skip_relocation, ventura:        "e764bd428332103a68a124c54e8e9f336888c248c2667d277b8a1e53d9ec9e4e"
    sha256 cellar: :any_skip_relocation, monterey:       "8e84f224f84db9dee8297289d597d2811b80fbc50594f7c759caa86d51bfc288"
    sha256 cellar: :any_skip_relocation, big_sur:        "ff637cb08353a4c7775df99ca600797fbeee1c0db9316d99957469ae7f3087d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "951e0b23959df0a4b05b46c7df7b8c24ce682444ee81361fbaf1d8f118129726"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/yamlfmt"
  end

  test do
    (testpath/"test.yml").write <<~YAML
      foo: bar
    YAML
    system bin/"yamlfmt", "-lint", "test.yml"
  end
end
