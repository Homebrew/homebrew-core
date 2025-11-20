class Xtermcontrol < Formula
  desc "Control xterm properties such as colors, title, font and geometry"
  homepage "https://thrysoee.dk/xtermcontrol/"
  url "https://thrysoee.dk/xtermcontrol/xtermcontrol-3.10.tar.gz"
  sha256 "3eb97b1d9d8aae1bad4fe2c41ca3a3dbb10d2d67e6ca4599aa1f631a40503dee"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?xtermcontrol[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3d4a267b1c10ee1076e61d3d07f3145f6162f85f8105aa40c5f637a24372d61f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "91e3dd1b814e1b6fb24ddff2fbc094d1126e9c88e156e8f66291dd0c25a84aa9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1631d01a3eee1cf04f37e7d01dcdb6d7066221ea94990b6a429f322acabcc5db"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "816846a55ddf739e1d3f34f7e11c7280fd3ecca79c51a65a42e749bda0e80f0c"
    sha256 cellar: :any_skip_relocation, sonoma:        "9f3d0725dc8f0531f83b61cf552c46db71c3bcf63fb0580e9e4682d6fe63eb44"
    sha256 cellar: :any_skip_relocation, ventura:       "678d0bb992613a535f7381fb59483f893dac21057bace98338fbbdd9102c1cb7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cd86332aa4be9f0a12c74cc5c5998a522828586e107fbdc8a46862d14f2ed53f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "10810f15d508c5a29c6df7ff1b757d6c2bac3d332772bb0ba142aa7e687fc1d8"
  end

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/xtermcontrol --version")

    expected = if OS.mac?
      "--get-fg is unsupported or disallowed by this terminal"
    else
      "failed to get controlling terminal"
    end

    ret_code = OS.mac? ? 0 : 1
    assert_match expected, shell_output("#{bin}/xtermcontrol --force --get-fg 2>&1", ret_code)
  end
end
