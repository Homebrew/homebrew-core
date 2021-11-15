class Serialosc < Formula
  desc "Opensound control server for monome devices"
  homepage "https://github.com/monome/docs/blob/gh-pages/serialosc/osc.md"
  url "https://github.com/monome/serialosc.git",
      tag:      "v1.4.3",
      revision: "12fa410a14b2759617c6df2ff9088bc79b3ee8de"
  license "ISC"
  head "https://github.com/monome/serialosc.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_monterey: "307d8cd2d6a4a8cedbb5728dcc4f68175b5428c2d54b289b8dea2c08b6a8e488"
    sha256 cellar: :any, arm64_big_sur:  "5673c0c56aa3e2186f6e55b78113002271bec33965eebfb06cf05a7a747e86ae"
    sha256 cellar: :any, monterey:       "06e151c06f2e85ce09ffddb18495a9433d3c18d236b8863afcdcd1df96995e3b"
    sha256 cellar: :any, big_sur:        "8be259522efad498f49fbd29b5ca2ea43280913573f100b032b488842385b7ed"
    sha256 cellar: :any, catalina:       "34a644c3acf33d0c5bd2416a987e370ceb328024c0d51837c143784fa61dcd67"
    sha256 cellar: :any, mojave:         "5a3de26553f48565604602e830be11e3334663dd839b83890a7545b5024631a2"
  end

  depends_on "confuse"
  depends_on "liblo"
  depends_on "libmonome"

  def install
    system "./waf", "configure", "--prefix=#{prefix}"
    system "./waf", "build"
    system "./waf", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/serialoscd -v")
  end
end
