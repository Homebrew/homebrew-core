class Yamlfmt < Formula
  desc "Extensible command-line tool to format YAML files"
  homepage "https://github.com/google/yamlfmt"
  url "https://github.com/google/yamlfmt/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "15148a9ab8562a5514dbdb22348ac10d1ac9a63f57fc9e5e4138bbf6146767dc"
  license "Apache-2.0"
  head "https://github.com/google/yamlfmt.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e0b8c469f4ea5763210196cac0559cf4af4dc55be045fd64d601163a40b4bd7a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "47b6975bcb89b9036bd675036b5b336b60a3f87a7bf4e7c8d2bf06ca85b3d0ba"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b7c5e22e842081e375399c15e8e7ccf037561e2bac51b2bb259d4c9c7212165f"
    sha256 cellar: :any_skip_relocation, sonoma:         "e10c21d430b641d39c0798f2c890f7628b44d42ab4f99229fed936b2b38c9a9c"
    sha256 cellar: :any_skip_relocation, ventura:        "30eee693734fc1f71bf2c67b1bc7e4dfaccdf64e8b1ad2997719000961fdbaea"
    sha256 cellar: :any_skip_relocation, monterey:       "d68f766149e173cc19dd3275c19e931d09add173f9c6e6b4c66b0679e41c77dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7d1bfa0101976985cb399566af4e0f1b0921b484618d04dd32372d0ff308c34d"
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
