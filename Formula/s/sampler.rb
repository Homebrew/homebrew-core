class Sampler < Formula
  desc "Tool for shell commands execution, visualization and alerting"
  homepage "https://sampler.dev"
  url "https://github.com/sqshq/sampler/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "8b60bc5c0f94ddd4291abc2b89c1792da424fa590733932871f7b5e07e7587f9"
  license "GPL-3.0-only"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "aca2f9375a5efc43bcd98549ac7d7ba6becd88a86ba41b5791b9d751260d0616"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "2e9165271f6debe06db6e23f46c13a13b603924e65597f85bb428a1b27780ee1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0122ac71d3af643458faa2633740d3fd8256bd943ae7d212a6397ce9ff6f39a6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ae4392df3f779677167dde63083627a60da11e80c1afac173f5ae67bd4e1f495"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7ba9d52f3a2030da4c3c5464e5286907ff9f614d50f11555aa780f2087121f93"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "330a2e3de5d8352c9d11fa8d7f850b8fe41f869b2ec6f953944a500d0ba2143b"
    sha256 cellar: :any_skip_relocation, sonoma:         "d85ed3f3b130be8bf7141e9c7b236668c1f758f0a1ed86e7cb0d6d98d1457ae8"
    sha256 cellar: :any_skip_relocation, ventura:        "6fd6a327e70bc18043da635cb29864cd21e85edf1268a47fb577babceb336c01"
    sha256 cellar: :any_skip_relocation, monterey:       "56b5b7b0cd61ff5557cbf5c58bb25b793de0a17303292f2c28b2d73584650a5d"
    sha256 cellar: :any_skip_relocation, big_sur:        "3dd48615b2dd049e17d2635df81cd8f312e004d2e9c50a0d68d7f4f40516e61c"
    sha256 cellar: :any_skip_relocation, catalina:       "1b4a4c841691d8a6ca9ea4649092684511bff1f60d7d80e364db13115f2e6399"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "2bb024eb1121fcbdb7591fc43d76192122a98b1e0f8805151fac95108e8ea20a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "71d294afc5ecad041132801fa2d6848f8e4fa1ca1756b2d17b440f23ccaa11ec"
  end

  depends_on "go" => :build

  on_linux do
    depends_on "alsa-lib"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_includes "specify config file", shell_output(bin/"sampler")
  end
end
