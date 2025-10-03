class Spek < Formula
  desc "Acoustic spectrum analyser"
  homepage "https://www.spek.cc"
  url "https://github.com/alexkay/spek/releases/download/v0.8.5/spek-0.8.5.tar.xz"
  sha256 "1bccf85a14a01af8f2f30476cbad004e8bf6031f500e562bbe5bbd1e5eb16c59"
  license "GPL-3.0-or-later"
  revision 5

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5a7906a3f0fb330c1e1646fdda11d561f67868b95144e2524e2a5563ba17c310"
    sha256 cellar: :any,                 arm64_sequoia: "5d4388acbd2adc2e46f4efd39bfc028aa3235d3bc97aed3fb025e7b8387ca036"
    sha256 cellar: :any,                 arm64_sonoma:  "f41ddbde93ab3cdbce6c949b3607a2d77068a7fff377d6902752636347a9c3f6"
    sha256 cellar: :any,                 arm64_ventura: "228c5ca814faaef7d3d2182ecb10fda16e8d33bd4ff4194b61d8732f86687e81"
    sha256 cellar: :any,                 sonoma:        "76e769f535f5e3a4139447ac9ac7348f660ee4bfb016cc2ed9bdc9d356fc2b8b"
    sha256 cellar: :any,                 ventura:       "cf266c54c4e3b363c902715216e61a4ef90837b5ae36631e0700068d7eb20d4d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "be666699556a55ff1a7e9aea8b6615c7c4c26390d9dba1d54fef65c81afbf919"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "361440ed42bfd45dc6c00d23839b5170e7be9e00231a131a882f645e712b7729"
  end

  depends_on "pkgconf" => :build
  depends_on "ffmpeg@7"
  depends_on "wxwidgets"

  def install
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make"

    # https://github.com/alexkay/spek/issues/235
    cp "data/spek.desktop.in", "data/spek.desktop" if OS.linux?

    system "make", "install"
  end

  test do
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"].present?

    assert_match "Spek version #{version}", shell_output("#{bin}/spek --version")
  end
end
