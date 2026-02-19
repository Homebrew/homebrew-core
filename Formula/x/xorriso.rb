class Xorriso < Formula
  desc "ISO9660+RR manipulation tool"
  homepage "https://www.gnu.org/software/xorriso/"
  url "https://ftpmirror.gnu.org/gnu/xorriso/xorriso-1.5.6.pl02.tar.gz"
  mirror "https://ftp.gnu.org/gnu/xorriso/xorriso-1.5.6.pl02.tar.gz"
  version "1.5.6.pl02"
  sha256 "786f9f5df9865cc5b0c1fecee3d2c0f5e04cab8c9a859bd1c9c7ccd4964fdae1"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(/href=.*?xorriso[._-]v?(\d+(?:\.\d+)+(?:\.pl\d+)?)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fceeb65166fc6b9aec4b74b77897da475a890384717df9ebc46488a3bfbcdeb5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "695c33db8e91cf5c45d8024768eeeaa32d7d51268344d150367355c569b70518"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5c85c0022f31b62c5e5949ecfacc9178ef58afb8ef8a89fb9bfeadca4326980b"
    sha256 cellar: :any_skip_relocation, sonoma:        "7393a7926142ea960892a3b72efc423f4600ebe0be7cf089f8d94201edd5c5e8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c6bf70c1bb510be7dee6854d6e6ef20c69da79b2c080d42c3d0a2b84c8f783c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0f19040f286ffb85071c95e2633570117b4fa2e68196c3d42b2ca178ec8d8805"
  end

  on_linux do
    depends_on "acl"
    depends_on "zlib-ng-compat"
  end

  def install
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make"

    # `make install` has to be deparallelized due to the following error:
    #   mkdir: /usr/local/Cellar/xorriso/1.4.2/bin: File exists
    #   make[1]: *** [install-binPROGRAMS] Error 1
    # Reported 14 Jun 2016: https://lists.gnu.org/archive/html/bug-xorriso/2016-06/msg00003.html
    ENV.deparallelize { system "make", "install" }
  end

  test do
    assert_match "List of xorriso extra features", shell_output("#{bin}/xorriso -list_extras")
    assert_match version.to_s, shell_output("#{bin}/xorriso -version")
  end
end
