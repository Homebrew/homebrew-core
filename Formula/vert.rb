class Vert < Formula
  desc "Command-line version testing"
  homepage "https://github.com/Masterminds/vert"
  url "https://github.com/Masterminds/vert/archive/v0.1.0.tar.gz"
  sha256 "96e22de4c03c0a5ae1afb26c717f211c85dd74c8b7a9605ff525c87e66d19007"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ca2bb8a7baed5c1492df0b25d59fe36c64322eafd1e88e68b6c8c59461ecf392"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fefcb555229fd32ff09eba5ae165b7c94900c062d495af82535eb2ce4cc0ea57"
    sha256 cellar: :any_skip_relocation, monterey:       "850d7a05d18ea7a91664f0e520c7c9c8db83611eab597da8c71d1c35c3103264"
    sha256 cellar: :any_skip_relocation, big_sur:        "197d3e5dd45083a371c761a33654937bf1c61bd94ba8d1ef063090e8d90a8b62"
    sha256 cellar: :any_skip_relocation, catalina:       "fe4638da084954ff52f94c69318502808134ab73d84f1acac44bb62d3922af5c"
    sha256 cellar: :any_skip_relocation, mojave:         "a2fbb031b72d6b4524dc31add5536acef1fdb913c5db28240bd4352c107da638"
    sha256 cellar: :any_skip_relocation, high_sierra:    "b7c63c671335e19afca83f08091a987c35576eb4cb94f1d7b00490d1448f3e77"
    sha256 cellar: :any_skip_relocation, sierra:         "e189a592a062ef9e2cc19506f99272ffc9f97f3e529a54eddd7287f0c9574935"
    sha256 cellar: :any_skip_relocation, el_capitan:     "534043c69cbd56a22d656ba873e180e628b3a0ace433d8f020b886212afa050e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ed8cfcf0ce2cb0fcf0ad6bccea62e3726009131681e68c85e60d88b9135d10b6"
  end

  deprecate! date: "2021-07-29", because: :unmaintained

  depends_on "dep" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "auto"
    (buildpath/"src/github.com/Masterminds/vert").install buildpath.children
    cd "src/github.com/Masterminds/vert" do
      system "dep", "ensure", "-vendor-only"
      system "make", "build"
      bin.install "vert"
      prefix.install_metafiles
    end
  end

  test do
    output = shell_output("#{bin}/vert 1.2.3 1.2.3 1.2.4 1.2.5", 2)
    assert_match "1.2.3", output
  end
end
