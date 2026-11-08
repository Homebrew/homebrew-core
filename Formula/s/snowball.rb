class Snowball < Formula
  desc "Stemming algorithms"
  homepage "https://snowballstem.org"
  url "https://github.com/snowballstem/snowball/archive/refs/tags/v3.2.0.tar.gz"
  sha256 "c33aea097734daae5c445efe6e399cb078f66325b40d54791df577ffaa53c2d7"
  license "BSD-3-Clause"
  compatibility_version 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c487473f786dc0c10f37b678ad70f0044ecbaa4e134f3953db19a35c8402b6ce"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "abce97574300d240298a7cfea629f1a4af66fe25cda0d30bf4f1a6e153afe942"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "26906139900128bd8fffd24feed75bfaf89f1306bfaf10cec8d103085eeccd98"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f588cd4ebb29b972a8f6e455f6bbe269a720783698c25737ac4b8c5fe46ec3b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "399433f043228d8f4e2f1f7dac771744c8f32d944382569d13690b202fa9bf62"
  end

  def install
    system "make"

    lib.install "libstemmer.a"
    include.install Dir["include/*"]
    pkgshare.install "examples"
  end

  test do
    (testpath/"test.txt").write("connection")
    cp pkgshare/"examples/stemwords.c", testpath
    system ENV.cc, "stemwords.c", "-L#{lib}", "-lstemmer", "-o", "test"
    assert_equal "connect\n", shell_output("./test -i test.txt")
  end
end
