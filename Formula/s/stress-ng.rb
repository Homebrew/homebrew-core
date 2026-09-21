class StressNg < Formula
  desc "Stress test a computer system in various selectable ways"
  homepage "https://wiki.ubuntu.com/Kernel/Reference/stress-ng"
  url "https://github.com/ColinIanKing/stress-ng/archive/refs/tags/V0.22.01.tar.gz"
  sha256 "67e75894da3f634b85992069b0a888893221a77a3db5e3293cdddd0b1c0d4705"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ced5cd151919780b08fc206650f23dc01fb5cf1ad06f7d37e904b52f7f63ee20"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "89e5522a96b8ac5e7a6c2dfdf47d776dfe422d6afe74b9fb47c6c47b386d1771"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c0f6252ad12b0d9239f9598350fab913dc85416ca92f3b90ee31f0ab01b630c7"
    sha256 cellar: :any,                 arm64_linux:       "924f9ff216b76ba6d4d4322a08324ce6de50a9efab1395c763c399a75338699f"
    sha256 cellar: :any,                 x86_64_linux:      "51a1e51d71cc6c9f49c8fac0719e7405e5263c6954492b8f2029d3528eab0133"
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
