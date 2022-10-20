class Sampler < Formula
  desc "Tool for shell commands execution, visualization and alerting"
  homepage "https://sampler.dev"
  url "https://github.com/sqshq/sampler/archive/v1.1.0.tar.gz"
  sha256 "8b60bc5c0f94ddd4291abc2b89c1792da424fa590733932871f7b5e07e7587f9"
  license "GPL-3.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7ba9d52f3a2030da4c3c5464e5286907ff9f614d50f11555aa780f2087121f93"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "330a2e3de5d8352c9d11fa8d7f850b8fe41f869b2ec6f953944a500d0ba2143b"
    sha256 cellar: :any_skip_relocation, monterey:       "56b5b7b0cd61ff5557cbf5c58bb25b793de0a17303292f2c28b2d73584650a5d"
    sha256 cellar: :any_skip_relocation, big_sur:        "3dd48615b2dd049e17d2635df81cd8f312e004d2e9c50a0d68d7f4f40516e61c"
    sha256 cellar: :any_skip_relocation, catalina:       "1b4a4c841691d8a6ca9ea4649092684511bff1f60d7d80e364db13115f2e6399"
    sha256 cellar: :any_skip_relocation, mojave:         "b50240b4f199da6d55d4645dfd3d2b0fc3406d20a504ba9af4d3b545196438b1"
    sha256 cellar: :any_skip_relocation, high_sierra:    "163b575ff369f264605bdc69c0fc838e44e706f8b6c527bb343cbfb18a9b1fdc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "71d294afc5ecad041132801fa2d6848f8e4fa1ca1756b2d17b440f23ccaa11ec"
  end

  depends_on "go" => :build

  on_linux do
    depends_on "alsa-lib"
  end

  def install
    system "go", "build", "-o", bin/"sampler"
  end

  test do
    assert_includes "specify config file", shell_output("#{bin}/sampler")
  end
end
