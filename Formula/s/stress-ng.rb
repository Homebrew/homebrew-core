class StressNg < Formula
  desc "Stress test a computer system in various selectable ways"
  homepage "https://wiki.ubuntu.com/Kernel/Reference/stress-ng"
  url "https://github.com/ColinIanKing/stress-ng/archive/refs/tags/V0.21.04.tar.gz"
  sha256 "a328ba050bd3014f07a3265fb6c1aab071ae942dfad75c7459cce45a987869e1"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5d0fe742cb593988c276eec23f74e35d0cf3ae528037267ab4168aa13d00edf1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c03deaf3713b169e01e17ed3cdbe7d98f2ade94a02b44a899ff5e4863cf8aa3f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "176d11bc4f7ef6594573120248a55ad0f9c8ad0d7a378377edbcf94ba5c71593"
    sha256 cellar: :any_skip_relocation, sonoma:        "3ffc596aba5e5b7a97445d59cb39495c4950c324c63582349ff52aac2acda0c7"
    sha256 cellar: :any,                 arm64_linux:   "7e922e1732b2e9a974ba41941a8ce1cb793002e522edac6dcb34ff54af886182"
    sha256 cellar: :any,                 x86_64_linux:  "b8554ed57ec2416c0c9b0f195f84e63493e8e4b66e3535e1294f358685b1be83"
  end

  uses_from_macos "libxcrypt"

  on_linux do
    depends_on "acl"
    depends_on "zlib-ng-compat"
  end

  def install
    # disable target_clones so no non-baseline (AVX-512) code lands in the bottle
    ENV.append_to_cflags "-DHAVE_BUILD_SMALL" if Hardware::CPU.intel?

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
