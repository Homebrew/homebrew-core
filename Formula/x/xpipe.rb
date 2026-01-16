class Xpipe < Formula
  desc "Split input and feed it into the given utility"
  homepage "https://www.netmeister.org/apps/xpipe.html"
  url "https://www.netmeister.org/apps/xpipe-2.2.tar.gz"
  sha256 "a381be1047adcfa937072dffa6b463455d1f0777db6bc5ea2682cd6321dc5add"
  license "BSD-2-Clause"

  livecheck do
    url "https://www.netmeister.org/apps/"
    regex(/href=.*?xpipe[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "0e886c34608112f333f208e802b5e9fd4f40b336db9cb14629a7e0c6142891e4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "d889986ca2f5379e8f1d22e5add2ce9a3295b5625a93e4416bc737625ded5ea4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "98fdb15f477e02081958ff3a24be3d78c9d4387fce7ccba7107fbf5aa9debdac"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a3575ecac45489a48910ea50fcba01e11128b12f761f8a123edbda73967482c1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "67c0fd303c2cf6076676cacd1efb20db78ba3de9282d57b901c0cfdf550bd742"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1ce7b92989b8db7377383649d3bda4615dfc76c978d53ccbf526b8329729ed2b"
    sha256 cellar: :any_skip_relocation, sonoma:         "1ce4bd5f2579c4c6c65e18b54f4ccc0a20bb95ad3cb1d76126300f709f67a50e"
    sha256 cellar: :any_skip_relocation, ventura:        "449fe37a5a028c9335f6750c41c60be9118b58ea4a5932e5244406eac6074974"
    sha256 cellar: :any_skip_relocation, monterey:       "f7b7d07da19d055e33168745cc88dc681bf8122bfc42a69baed6af85182b3f8e"
    sha256 cellar: :any_skip_relocation, big_sur:        "be1f56555c5846777c0a963cbf01f71f2b7fe5c6ca7fb17240fbcaf7937ccfdd"
    sha256 cellar: :any_skip_relocation, catalina:       "06e9e1e3cb21acd053c218d5c0e34eb591bb54f7031b98b27116b302512cfc3a"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "fb963f6a0f7bd758bc4ade850635c64cad0c8955455d4aa8f3ad600fff8c1895"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "85269e2a82a5296f82eaba5e4fc1004ac1176cb1d2f672a7865480fcde33a452"
  end

  on_linux do
    depends_on "libbsd"
  end

  def install
    inreplace "Makefile", "${PREFIX}/include/bsd", "#{Formula["libbsd"].opt_include}/bsd"
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system "echo foo | xpipe -b 1 -J % /bin/sh -c 'cat >%'"
    assert_path_exists testpath/"1"
    assert_path_exists testpath/"2"
    assert_path_exists testpath/"3"
  end
end
