class StressNg < Formula
  desc "Stress test a computer system in various selectable ways"
  homepage "https://github.com/ColinIanKing/stress-ng"
  url "https://github.com/ColinIanKing/stress-ng/archive/refs/tags/V0.22.02.tar.gz"
  sha256 "860004ce7484311b3296fc52796fbbc34dfb7f644a769bbd4e03935b7a1b0ccb"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "fc37e8ae7f27f0d18d026b4554dbac54c79b217b08a8d05515632065753866bd"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8ecb465d8d5f161536b609312f772c7d2d45b87f1e109ba05a7f6bbc04dd176e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0a68e10e4bd7b54adc836d3e4b06ec13fdbdc78fd0f4b683817a4039524afc0a"
    sha256 cellar: :any,                 arm64_linux:       "b1d7336b61f50d0d8c8bc1f95dad4eda09ae2bbeccbd4e38c057cd4b97dc7ebb"
    sha256 cellar: :any,                 x86_64_linux:      "1ddd158c578655076e75e6a9b199c4c71349907edea0c5da3c10b0ea882d64ff"
  end

  uses_from_macos "libxcrypt"

  on_linux do
    depends_on "acl"
    depends_on "gmp"
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
