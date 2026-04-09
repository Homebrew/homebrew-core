class StressNg < Formula
  desc "Stress test a computer system in various selectable ways"
  homepage "https://wiki.ubuntu.com/Kernel/Reference/stress-ng"
  url "https://github.com/ColinIanKing/stress-ng/archive/refs/tags/V0.21.00.tar.gz"
  sha256 "1339cbc6ccbff7e2ee2177bf0fd67e7b94e8ff7b07fe89bcfaec0280d800cf34"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c263f5c6e997c7e388e9ee8be9eee33e901af11b9cca58f8f5998e2d67515e1a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a2f2bc25da24e9ea9d66531c99630d0d2af0158b9531401a67891e21d10d5229"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e39dc242bd6c2f848cd9ee3151b060ccabec8e81f8421d55af52fa55d2f90ade"
    sha256 cellar: :any_skip_relocation, sonoma:        "b43e3627f435901273def8fc2dbdd6731393c6b8dca3d7e11448bacb0f81b672"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1d890c784813e93215aff2a62dd226f067bfc6ebb960fb52d780eab7ad268aff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7f3f321d85c582369a921d8f21726bd2543dddfe787c44621d81a8cbdbd57004"
  end

  uses_from_macos "libxcrypt"

  on_linux do
    depends_on "acl"
    depends_on "zlib-ng-compat"
  end

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
