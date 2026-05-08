class StressNg < Formula
  desc "Stress test a computer system in various selectable ways"
  homepage "https://wiki.ubuntu.com/Kernel/Reference/stress-ng"
  url "https://github.com/ColinIanKing/stress-ng/archive/refs/tags/V0.21.01.tar.gz"
  sha256 "4c898d9b1911124f43f1fb6a18a725badbe795f5b628531afd4b631127ad8073"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a230c72c9e274134c448a8d4f921276abca011af8b31df187f083f24e94debc6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ac952d95b34f23415731926053ab7ee3699e3b7fc70e2bdfb6c167b15d50bdf8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "31b62b203482954fd4f6f2d7fd8e61d72dc960ba2157cd8d67c226e4cedf3e56"
    sha256 cellar: :any_skip_relocation, sonoma:        "5a58d1af2ae3c6a1dbcc3d5eac1be6b9ee5a253343e628bcaa9f0e8bb32096d0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fae2f4385dac7ca81b9a4e7ba53ffd33d05279a016b86d0c5964755d66c7905a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9c90622727f4c0a2cc0df253b106a7ef94b8be28466aaccd7f41ca7b428c87af"
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
