class Radamsa < Formula
  desc "Test case generator for robustness testing (a.k.a. a \"fuzzer\")"
  homepage "https://gitlab.com/akihe/radamsa"
  url "https://gitlab.com/akihe/radamsa/-/archive/v0.7/radamsa-v0.7.tar.gz"
  sha256 "d9a6981be276cd8dfc02a701829631c5a882451f32c202b73664068d56f622a2"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c6fba460536c28334781bb3c1d5471794de9e6ab3ccd64bf9a9ee67dbfcaae8f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "68a800cd47ad72dcaf605c67d01e86fab1af8c40b678f06317489887d3d1eeb3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4868ee9e0dcbe6da781d40d6a513e2185ba0b8e09a125eca2dbb36c8e5cb4ab3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "568e7f3b24edb8d8aca56b0835eea5fcd32dff97d2c2a2985362329bf8555169"
    sha256 cellar: :any_skip_relocation, sonoma:        "2535c22f7a6faf37a7b7ffb7eab908de0a0d265e4f887718a65ef7b7d9d015f0"
    sha256 cellar: :any_skip_relocation, ventura:       "1463cedbf5969dc913d6878fab2a860d9aefd4d9a80f960ee8383086c6d17806"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d9e5bd4345a4a6858c4dc6ecabbadb8d920bcc8941241e1300fc11ec9931b335"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c32fe0dcf5a76ce7251b8caebf2ecdd09427990a52c88adfd993efeae138fe41"
  end

  # https://gitlab.com/akihe/radamsa/-/blob/v#{version}/Makefile?ref_type=tags#L7
  resource "ol.c" do
    url "https://haltp.org/files/ol-0.2.2.c.gz"
    version "0.2.2"
    sha256 "fca85dae36910108598d8a4a244df7a8c2719e7803ac46d270762ece4aefc55c"

    livecheck do
      url "https://gitlab.com/akihe/radamsa/-/raw/v#{LATEST_VERSION}/Makefile?ref_type=tags"
      regex(/OWLURL=.*?ol[._-]v?(\d+(?:\.\d+)+)\.c/i)
    end
  end

  def install
    resource("ol.c").stage { buildpath.install Dir["*"].first => "ol.c" }
    system "make", "install", "PREFIX=#{prefix}"
    # Manually replace the manpage which is not reproducible
    rm(man1/"radamsa.1.gz")
    man1.install Utils::Gzip.compress("doc/radamsa.1")
  end

  test do
    assert_match "Radamsa is a general purpose fuzzer.", shell_output("#{bin}/radamsa --about")
    assert_match "drop a byte", shell_output("#{bin}/radamsa --list")
    assert_match version.to_s, shell_output("#{bin}/radamsa --version")
  end
end
