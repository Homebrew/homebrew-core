class Stencil < Formula
  desc "Smart templating engine for service development"
  homepage "https://engineering.outreach.io/stencil/"
  url "https://github.com/getoutreach/stencil/archive/refs/tags/v1.39.1.tar.gz"
  sha256 "eeea270807ca5d9f5934195ff2aab2e0762e40a756305635cb998dc52507fb42"
  license "Apache-2.0"
  head "https://github.com/getoutreach/stencil.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dd8711235c5bdd57afcf109fc6e1e0f80e25a8faeeae0a0effbad48b860102e9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "74636ebf55d44de21f76bee54501201ea149288a2b7504f3ea4d6f24d40e7090"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "180c3b992d097cfa43f1f6f7a5855d78354d41a1087405b3269ffb9348f76a12"
    sha256 cellar: :any_skip_relocation, sonoma:         "7b57b1cb44d9375d23e56d7b4dd23cdeb59987f72c6788d133f94857594b20ae"
    sha256 cellar: :any_skip_relocation, ventura:        "9e1d19e51ccd985d1b95a3c27d5f241fd59b75461d0a4677bfd332a5e36ea393"
    sha256 cellar: :any_skip_relocation, monterey:       "d3231484aa397a4efc14600313971d09732bd2fcf10559f0d5f25907c5611593"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b045dc18f866ac6c5a1d3ca9b4f37d5dae7a074db806a0a123f29ee98aec0a27"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/getoutreach/gobox/pkg/app.Version=v#{version} -X github.com/getoutreach/gobox/pkg/updater/Disabled=true"),
      "./cmd/stencil"
  end

  test do
    (testpath/"service.yaml").write "name: test"
    system bin/"stencil"
    assert_predicate testpath/"stencil.lock", :exist?
  end
end
