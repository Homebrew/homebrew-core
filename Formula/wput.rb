class Wput < Formula
  desc "Tiny, wget-like FTP client for uploading files"
  homepage "https://wput.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/wput/wput/0.6.2/wput-0.6.2.tgz"
  sha256 "229d8bb7d045ca1f54d68de23f1bc8016690dc0027a16586712594fbc7fad8c7"
  license "GPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, monterey:     "39c0ebbfc7502644b9df207fae398036caef7cfcee63d340776d036893964610"
    sha256 cellar: :any_skip_relocation, big_sur:      "2a5d49be96808777f249d96b6f86e2e0e0e301be0e929ba1eaea99cf79cacf42"
    sha256 cellar: :any_skip_relocation, catalina:     "77703d5dfb1bde183ccc207ee5e3f14b1a677acc697806a2b16f00c56cc0595e"
    sha256 cellar: :any_skip_relocation, mojave:       "563c5204880172786cbbfc75dafa818e670ac5d1a67fdbe8bea1dd2588587eab"
    sha256 cellar: :any_skip_relocation, high_sierra:  "e01d35805cd00e8f4d9ba1ab989104d66dc4150648a2288f5f49eea5c17b5025"
    sha256 cellar: :any_skip_relocation, sierra:       "0a8c4296a3e14d8b420f65464293b000dd1bd2e33a802c92e1812f0c267d3f0f"
    sha256 cellar: :any_skip_relocation, el_capitan:   "8e4eeb941d98dc0313b87682b7ae659bbceac59426cf0483c2ae2676cf5b924b"
    sha256 cellar: :any_skip_relocation, yosemite:     "97bc045a03ddd01106304530a453a47693fbd5f3419090310c91a187e1d23931"
    sha256                               x86_64_linux: "0fb27e180b9a6f8ef2b3508530874b467449fdac55a347c63f2e86ca360db073"
  end

  # The patch is to skip inclusion of malloc.h only on OSX. Upstream:
  # https://sourceforge.net/p/wput/patches/22/
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/85fa66a9/wput/0.6.2.patch"
    sha256 "a3c47a12344b6f67a5120dd4f838172e2af04f4d97765cc35d22570bcf6ab727"
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    ENV.deparallelize
    system "make", "install"
  end

  test do
    system "#{bin}/wput", "--version"
  end
end
