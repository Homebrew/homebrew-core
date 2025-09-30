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

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ec2aac72e501138766c226d4983498f05536f216da04286b8457aec12f20bf7a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4ce9aa17c62698d61ba30175e05e730cdbfb45c00f414728e344912d8f533e50"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1c0d17d1c03669586c4d7f5e10c915ff46e0448b65838ad8f4b4b9cda589f0b9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cb072e208fba6a3d7e100b173dabba79aad125900499366ae5c876223d51589e"
    sha256 cellar: :any_skip_relocation, sonoma:        "d4c500ee979adcd61b5f7fd5790992ebd1209d7d778244d39e5b070ad317b62e"
    sha256 cellar: :any_skip_relocation, ventura:       "6d06e4c85a3b819c1b0f6209de9ff66be94464f5f7ffc6e54987c1a9808417d6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5e2de74c4a0f1472e99be18ad1810410378eb0597aad77e666657ee80ec932c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "db3610de57dbb6a1b2bf32776acc9803efe9a951791101692eb65dc6df1226bd"
  end

  uses_from_macos "zlib"

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
