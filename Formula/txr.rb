class Txr < Formula
  desc "Lisp-like programming language for convenient data munging"
  homepage "https://www.nongnu.org/txr/"
  url "http://www.kylheku.com/cgit/txr/snapshot/txr-288.tar.bz2"
  sha256 "89ea8133da67c164077691c073308c5ea62aa4fd19bfa01f2f60ec1e252717ff"
  license "BSD-2-Clause"

  livecheck do
    url "http://www.kylheku.com/cgit/txr"
    regex(/href=.*?txr[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0fa037376fb4d097cf6b5feb89f6c3639907957eabf860ac00fe3fd019aec795"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "818fa61a67a0697aa755b02e27c4fe59581f46f5dcfbf3f1282458ca45d44bfa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b5261b83f4c648d1155ed846e96c7ab3a26e415ba39fb213b5dc5f91ebd5a5ed"
    sha256 cellar: :any_skip_relocation, ventura:        "49e3dbaf7511199e293f4e75150f41a7a94de3b066fb898a6dd520fc3796babc"
    sha256 cellar: :any_skip_relocation, monterey:       "7ac4d004d0f04e790262dfb3197d761f72fb2c6ac48b5d649bb5642123a93fa4"
    sha256 cellar: :any_skip_relocation, big_sur:        "595285cc5d8fc81704c3a1eb955ab058a0ebe867a03f3c477e4c1f442d23884c"
  end

  depends_on "pkg-config" => :build
  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "libffi", since: :catalina

  def install
    system "./configure", "--prefix=#{prefix}", "--inline=static inline"
    system "make"
    system "make", "install"
  end

  test do
    assert_equal "3", shell_output("#{bin}/txr -p '(+ 1 2)'").chomp
  end
end
