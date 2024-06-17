class Yamlfmt < Formula
  desc "Extensible command-line tool to format YAML files"
  homepage "https://github.com/google/yamlfmt"
  url "https://github.com/google/yamlfmt/archive/refs/tags/v0.12.1.tar.gz"
  sha256 "7ae88b90849b249a3cd97857796cc3a7ce2df408e3861c5f1d9ff24fade70b96"
  license "Apache-2.0"
  head "https://github.com/google/yamlfmt.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f66eee4e3dbaf68e2d60b2aa85bb24167cb6006fb40d2eedddd03fa543053212"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "299387b3548c46341b53b221a2a61084781979758f9832912f076b3ec2c4b5ee"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "63850d4ba066c6e67ad9c636acdfce94fa8ad1dab29870e381fdf5cd9c8e76d2"
    sha256 cellar: :any_skip_relocation, sonoma:         "fcbe543fe45f817e3b7785c9b9bffc99f17edb396e68022663643ee03fb29ca4"
    sha256 cellar: :any_skip_relocation, ventura:        "4b6afa3d923da19c52baa133cdba43a6b069be2ca4fadfa049e7ec369c9d1d1c"
    sha256 cellar: :any_skip_relocation, monterey:       "605ccd15db8672531b344206cefd2a789589f3b6ccd7592638234be819e173b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "92d943d56254e45c64d9463cb2dc9c7acf72bb1a3d5ad56d1dec209af16d24fa"
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
