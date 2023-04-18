class Spot < Formula
  desc "Platform for LTL and ω-automata manipulation"
  homepage "https://spot.lre.epita.fr"
  url "http://www.lrde.epita.fr/dload/spot/spot-2.11.4.tar.gz"
  sha256 "91ecac6202819ea1de4534902ce457ec6eec0573d730584d6494d06b0bcaa0b4"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://www.lrde.epita.fr/dload/spot/"
    regex(/href=.*?spot[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "d8e7729a50e467a4c379559bf26c79285b4be2f0b8f885735e460f490c6932fa"
    sha256 cellar: :any,                 arm64_monterey: "355ea35625911e1515e0f8e4f9ea7e66d949890872bc299fab1198fc0faacc71"
    sha256 cellar: :any,                 arm64_big_sur:  "5f43e08315fc87fc34a609d0f9d8f795612e459ffce3a2e0d31c4b6ef755eb02"
    sha256 cellar: :any,                 ventura:        "5b30a903b76a0ddba0281bb79d0665ccd61ea79b29f0ab6103c7913bc40de383"
    sha256 cellar: :any,                 monterey:       "fb48502928d10ee2403435ec1e6b1c1f96c4617c01c8da8b98968bed66feb6e8"
    sha256 cellar: :any,                 big_sur:        "cf3f09c8e7e9458aa91bf8aba8f73a526d7fd2790277658141cf1faea46f519b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f8f9c83e87be05182580eeb0855d6b47cae6f3c7ae617d3209f49204729bc15a"
  end

  depends_on "python@3.11" => :build

  fails_with gcc: "5" # C++17

  def install
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make", "install"
  end

  test do
    system bin/"randltl -n20 a b c d | ltlcross 'ltl2tgba -H -D %f >%O' 'ltl2tgba -s %f >%O' 'ltl2tgba -DP %f >%O'"
  end
end
