class TtyClock < Formula
  desc "Digital clock in ncurses"
  homepage "https://github.com/xorg62/tty-clock"
  url "https://github.com/xorg62/tty-clock/archive/v2.3.tar.gz"
  sha256 "343e119858db7d5622a545e15a3bbfde65c107440700b62f9df0926db8f57984"
  license "BSD-3-Clause"
  head "https://github.com/xorg62/tty-clock.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fa482bfe16706d591d196d62b30fd517e4b0e677ee9c320466a0f4021e6ad361"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "da788fd6f94799b9cb8fe52dae41d592871e9c7e422e216d90d08350f2f51a48"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fcae9d0e0eeaf68815b4a521f7f75c352d4188a38652b4841bd48b608120edce"
    sha256 cellar: :any_skip_relocation, ventura:        "29d7e07686de67b6b7e20cb51c72e756582aad75a15d3ca603751842ebe2bcbb"
    sha256 cellar: :any_skip_relocation, monterey:       "d2f40bb8f0155c0b2f5b22d2b6269a37c9fbd73976736476156969944e27bc1c"
    sha256 cellar: :any_skip_relocation, big_sur:        "fd72f43c25837763c243876436de51d99369fb8f540171aec16b2f66cb2870e3"
    sha256 cellar: :any_skip_relocation, catalina:       "dc5a60415f5cd5397d973b361db6bc0db2172621fe6eed037ee05c851097c27d"
    sha256 cellar: :any_skip_relocation, mojave:         "eab206747869e0190d82dfa71d7763df4a3f202c3035f7bccb5b32fc52580989"
    sha256 cellar: :any_skip_relocation, high_sierra:    "b3d2a19cdb38e0e156be552d6f9ca8926097300f17bbe6628b7443934d3e1cb1"
    sha256 cellar: :any_skip_relocation, sierra:         "9b0e056ec6d86d9ba9cbd2abc02236607a6ad5601e7a656d10cad20182564315"
    sha256 cellar: :any_skip_relocation, el_capitan:     "c0d981769811bf1c265e11702ea0d26bcf87102ac92896c04c14a91fbed1cc8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2b676f9ca583791e909a241667741a84289d4f75c5673fdd31176c48450ab701"
  end

  depends_on "pkg-config" => :build

  uses_from_macos "ncurses"

  def install
    ENV.append "LDFLAGS", "-lncurses"
    system "make", "PREFIX=#{prefix}"
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system "#{bin}/tty-clock", "-i"
  end
end
