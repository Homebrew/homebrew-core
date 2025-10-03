class TtyClock < Formula
  desc "Digital clock in ncurses"
  homepage "https://github.com/xorg62/tty-clock"
  url "https://github.com/xorg62/tty-clock/archive/refs/tags/v2.3.tar.gz"
  sha256 "343e119858db7d5622a545e15a3bbfde65c107440700b62f9df0926db8f57984"
  license "BSD-3-Clause"
  head "https://github.com/xorg62/tty-clock.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "d8de065838a148bed951b9e337b8a06f8db5fda6dd7c16a2b299b42a14b8730a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "7068bc510258482b8643c72d3cd98e5aeb11ec1c870a4f843b4dab323adc5437"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d9d3a157ca3d9c96d55c96e377ce0adf1033d388971438793fce2646976d5ab2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fa482bfe16706d591d196d62b30fd517e4b0e677ee9c320466a0f4021e6ad361"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "da788fd6f94799b9cb8fe52dae41d592871e9c7e422e216d90d08350f2f51a48"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fcae9d0e0eeaf68815b4a521f7f75c352d4188a38652b4841bd48b608120edce"
    sha256 cellar: :any_skip_relocation, sonoma:         "0531b48964a9b4deca9fcae4230bec9c9216f909405770f9d4460c450f819dd6"
    sha256 cellar: :any_skip_relocation, ventura:        "29d7e07686de67b6b7e20cb51c72e756582aad75a15d3ca603751842ebe2bcbb"
    sha256 cellar: :any_skip_relocation, monterey:       "d2f40bb8f0155c0b2f5b22d2b6269a37c9fbd73976736476156969944e27bc1c"
    sha256 cellar: :any_skip_relocation, big_sur:        "fd72f43c25837763c243876436de51d99369fb8f540171aec16b2f66cb2870e3"
    sha256 cellar: :any_skip_relocation, catalina:       "dc5a60415f5cd5397d973b361db6bc0db2172621fe6eed037ee05c851097c27d"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "fe5ad63f95c7fcbe74f39fff2206c1e8d20145d023e29ad783109632f8868308"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2b676f9ca583791e909a241667741a84289d4f75c5673fdd31176c48450ab701"
  end

  depends_on "pkgconf" => :build

  uses_from_macos "ncurses"

  def install
    ENV.append "LDFLAGS", "-lncurses"
    system "make", "PREFIX=#{prefix}"
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system bin/"tty-clock", "-i"
  end
end
