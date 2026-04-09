class Qstat < Formula
  desc "Query Quake servers from the command-line"
  homepage "https://github.com/Unity-Technologies/qstat"
  url "https://github.com/Unity-Technologies/qstat/archive/refs/tags/v2.18.tar.gz"
  sha256 "a74564bd9c31db3dc1fcc0a68ffaf694630b9e67f0d31ff76b2a3c3196ee4f1f"
  license "Artistic-2.0"

  bottle do
    sha256                               arm64_tahoe:   "c7a13c065f07c78ac3ece908defa738146039d54b9d3642e06d06766031e5d8e"
    sha256                               arm64_sequoia: "6268312f03fbb890419d8c4343dbff526567b7aa2aa537915160fd60f1080706"
    sha256                               arm64_sonoma:  "37c1e516e543cb130b2076a88a53bbf8eb1f7c6a25afe26fed10caba13043b29"
    sha256                               sonoma:        "dbe7c4cc53a379cd620bab83df9c7ed807b67b0793518b262139d465841b3eca"
    sha256                               arm64_linux:   "7e6d928552859166fd08ef486163d0894745c1b5b6c40b789205ab06c4208794"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ae181c9f7e61cb31c66d525ff2bcfd6da52c803e412b795e3009881879f0ca5"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  def install
    system "autoupdate" unless OS.mac?
    system "./autogen.sh"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"qstat", "--help"
  end
end
