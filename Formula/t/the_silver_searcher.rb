class TheSilverSearcher < Formula
  desc "Code-search similar to ack"
  homepage "https://geoff.greer.fm/ag/"
  url "https://github.com/ggreer/the_silver_searcher/archive/refs/tags/2.2.0.tar.gz"
  sha256 "6a0a19ca5e73b2bef9481c29a508d2413ca1a0a9a5a6b1bd9bbd695a7626cbf9"
  license "Apache-2.0"
  head "https://github.com/ggreer/the_silver_searcher.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "c9ef4b9e6cbcd7a5a0f2d489fe7b1c0c76384618ac42ff769783fe629de736fc"
    sha256 cellar: :any,                 arm64_sequoia:  "30781ad800cf0e58f863b36727ef2d78e8c2a84061a8e57cf6c269ab3a3e9594"
    sha256 cellar: :any,                 arm64_sonoma:   "fb4b711bc05b5c42950dffd4b21b867989524a9f8ee0ff91da42c09dbbf2fce2"
    sha256 cellar: :any,                 arm64_ventura:  "817b92ceac05e4860cdd5f7102289f55494359bb67c9fe4c8213d87b53261d7c"
    sha256 cellar: :any,                 arm64_monterey: "b567416368a9b131cf32f2c81400327a059da194c6d95df7368aa039fac73dfb"
    sha256 cellar: :any,                 arm64_big_sur:  "a1fa06a9147b1138f884408f88557357e4a48330373f720ca428aac0f3333221"
    sha256 cellar: :any,                 sonoma:         "c4d42f4505baa908ab3f441a3f15d7ac91f1ff62d2f443522a0e802f1e4388d4"
    sha256 cellar: :any,                 ventura:        "75b86330b34c4d6326b44c3f22f3b8e7fb912889e0a3765e5ef805b0127764b3"
    sha256 cellar: :any,                 monterey:       "613ce2a96feead807bb675c2a72388fdfde47b1f7702031909fc558dc0faf11f"
    sha256 cellar: :any,                 big_sur:        "e0fe6360a649e3a9722d72d258a65a4ec449e76e82166c9d0fc48530e73e952e"
    sha256 cellar: :any,                 catalina:       "6fd80fdd0896dae09c01d3c9785ddd658bb5f2f229e7d011d3fbdde887bc35d0"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "42693255381ed7eddc6ea74405580a839969b17cf657b52916b664ed301c12d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "08b2980ce1d36b89a1620934e9d513116bf2707396027d54a0096a088656228f"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkgconf" => :build
  depends_on "pcre"
  depends_on "xz"

  uses_from_macos "zlib"

  def install
    ENV.append_to_cflags "-fcommon" if ENV.compiler.to_s.start_with?("gcc")
    # Stable tarball does not include pre-generated configure script
    system "./autogen.sh"
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make"
    system "make", "install", "bashcompdir=#{bash_completion}"
  end

  test do
    (testpath/"Hello.txt").write("Hello World!")
    system bin/"ag", "Hello World!", testpath
  end
end
