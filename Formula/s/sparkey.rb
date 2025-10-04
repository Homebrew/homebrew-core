class Sparkey < Formula
  desc "Constant key-value store, best for frequent read/infrequent write uses"
  homepage "https://github.com/spotify/sparkey/"
  url "https://github.com/spotify/sparkey/archive/refs/tags/sparkey-1.0.0.tar.gz"
  sha256 "d607fb816d71d97badce6301dd56e2538ef2badb6530c0a564b1092788f8f774"
  license "Apache-2.0"
  revision 1

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "ff757da573f4fb8d73347565dec379edfd8b4310f03a563c98996b262c6a1226"
    sha256 cellar: :any,                 arm64_sequoia:  "452230974e3670cd4241c74f20a71fdeee5ce9f89ab939a5356745e5207bb43e"
    sha256 cellar: :any,                 arm64_sonoma:   "a7fc1a935b2c374f931ba2cef61f4c2a5fab149398dd95524d382423afca230b"
    sha256 cellar: :any,                 arm64_ventura:  "b5b1dd6314393471c6d94f5cd9417add5c2fb18cae43a8aadb55bc27782ff521"
    sha256 cellar: :any,                 arm64_monterey: "17187c82468ffb126744c6ac8f4bc318a11234923dd70759ed0b2204d949516f"
    sha256 cellar: :any,                 arm64_big_sur:  "1b2b1cc05fd4af9994aa34e57bc8767bdb567455e27458e1a9ac38e340603c68"
    sha256 cellar: :any,                 sonoma:         "8971cd97310bdd3351b32d80958eec379b95d8a3c18e31310a7453993ef5400d"
    sha256 cellar: :any,                 ventura:        "9f5be963c7067cdad5e22789cde8ca2eb21e9d587b538e57c228ab9b9bc90e1e"
    sha256 cellar: :any,                 monterey:       "8df24a5323536f451f373746c1a1643ce31967502c3d8cb99807ffca49e53413"
    sha256 cellar: :any,                 big_sur:        "6f469c28584124f46a7fa9835dee3311ef02d5a48f2d8fb8c8eb29f2c6688986"
    sha256 cellar: :any,                 catalina:       "b7e64101995d257df010edb67bafcd60745f09c7b0ebb9650c817eb7343f1899"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "a745bf0f972c860c306af016c89015bc1d39e1b5a90a1b553ff9fe65ca48e93b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9b9dcde71d3afafa413ad52116f880796bd49f1a715159a794275fb4bd366de1"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "snappy"

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
    mv bin/"bench", bin/"sparkey_bench"
  end

  test do
    system bin/"sparkey", "createlog", "-c", "snappy", "test.spl"
    assert_empty pipe_output("#{bin}/sparkey appendlog -d . test.spl 2>&1", "foo.bar")

    system bin/"sparkey", "writehash", "test.spl"
    assert_empty shell_output("#{bin}/sparkey get test.spi foo", 2)
  end
end
