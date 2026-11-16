class Snapraid < Formula
  desc "Backup program for disk arrays"
  homepage "https://www.snapraid.it/"
  url "https://github.com/amadvance/snapraid/releases/download/v15.2/snapraid-15.2.tar.gz"
  sha256 "0740169f66c506c29846a5aef57d2b11ffe5c354c5bb0ba260f2b5f328f985c5"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2f64ea3fac81ce492afc84f9f11908b13d2ee840264b7fad60c2dfceb8422843"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5061ccc0b54119eafca236e7d785d6862eb414ac6354f843ae369e6864cc34c6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ffa9f5a29ede49280602d252896d5508a9897be65914d8c82631e8e6f639e039"
    sha256 cellar: :any,                 arm64_linux:       "60283ee633221dcd64c1e3b3e74f9d2f358fa2e84fb04be15737ab8db415a3b0"
    sha256 cellar: :any,                 x86_64_linux:      "5e2ddeb564d2ad1f0f75039816278098ec984e463c3fbba3ff46c7ade1c44cc2"
  end

  head do
    url "https://github.com/amadvance/snapraid.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  deny_network_access!

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/snapraid --version")
  end
end
