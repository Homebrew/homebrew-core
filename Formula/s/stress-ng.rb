class StressNg < Formula
  desc "Stress test a computer system in various selectable ways"
  homepage "https://wiki.ubuntu.com/Kernel/Reference/stress-ng"
  url "https://github.com/ColinIanKing/stress-ng/archive/refs/tags/V0.17.08.tar.gz"
  sha256 "e4982d2a1c57139dad1741d6248b00a30935f746c1f665ec5b9d53c010c8dc08"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "96ef3ce7ef81e01256c5f0180115f6b2f895fd117c87c931853db1be0da0dd41"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "507ef538fb92109516ec979ece03f65f3456f08bdc1cb3d08ecfd64dd67716db"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "80b8debe6fd4eb05488b5418cfbf20d1ed8144e3c9f94e002860c10ffec12823"
    sha256 cellar: :any_skip_relocation, sonoma:         "1deb8f710f24d1d825e26868ec48a3e9d4cb92770a98d839eb8ec76d4db39838"
    sha256 cellar: :any_skip_relocation, ventura:        "28f40149370d5ca52fe150a1c95149e1d5b6ee2b228aa70b52a883eb23b912ae"
    sha256 cellar: :any_skip_relocation, monterey:       "aa2d5238a0c3f988b32bebe5e060db2c0dd6e73f4992c8132927d46f62feab01"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8b969937d5e40f229d725d2c482de4137a64a119350e20c8c8b6c6f41c344734"
  end

  depends_on macos: :sierra

  uses_from_macos "libxcrypt"
  uses_from_macos "zlib"

  def install
    inreplace "Makefile" do |s|
      s.gsub! "/usr", prefix
      s.change_make_var! "BASHDIR", prefix/"etc/bash_completion.d"
    end
    system "make"
    system "make", "install"
    bash_completion.install "bash-completion/stress-ng"
  end

  test do
    output = shell_output("#{bin}/stress-ng -c 1 -t 1 2>&1")
    assert_match "successful run completed", output
  end
end
