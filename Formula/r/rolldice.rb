class Rolldice < Formula
  desc "Rolls an amount of virtual dice"
  homepage "https://github.com/sstrickl/rolldice"
  url "https://github.com/sstrickl/rolldice/archive/refs/tags/v1.16.tar.gz"
  sha256 "8bc82b26c418453ef0fe79b43a094641e7a76dae406032423a2f0fb270930775"
  license "GPL-2.0-only"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "09a28787c7477eadf288aa7a5ae71453ad26dd4625bb10f16fc018268a30d3ab"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "031af343a052cfcf699f759e5437a87deb519e69a4a5e6eefb321b9e2e1076bf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1d08c666a00ef58322bc11b9082b063330b818186a6f6fb06ef65e92b599ed96"
    sha256 cellar: :any_skip_relocation, sonoma:        "9d31227c05f614fa803c1de1beba50ad7eafa06ac6f32afd8cf84af2798e778c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ebac82e928ab9231e039a3081c30662038cb584b9f3fb8bbca4c6eaa380440c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "92a41852d00239f7c3874e32f8cf7da6f8053a9ae0ddd906dd6e1f2c5da4176f"
  end

  uses_from_macos "libedit" # readline's license is incompatible with GPL-2.0-only

  # Submitted upstream at https://github.com/sstrickl/rolldice/pull/25
  # Remove if merged and included in a tagged release
  patch do
    url "https://github.com/sstrickl/rolldice/commit/5e53bade81d0fc972857889c1b690dcd830b439b.patch?full_index=1"
    sha256 "133214dcc8c8d8e4620205273c6c932cc0674e11717bf4b2fa432a205e825cc5"
  end

  def install
    unless OS.mac?
      ENV.append_to_cflags "-I#{Formula["libedit"].opt_libexec}/include"
      ENV.append "LDFLAGS", "-L#{Formula["libedit"].opt_libexec}/lib"
    end

    system "make", "CC=#{ENV.cc}"
    bin.install "rolldice"
    man6.install Utils::Gzip.compress("rolldice.6")
  end

  test do
    assert_match "Roll #1", shell_output("#{bin}/rolldice -s 1x2d6")
  end
end
