class Ssed < Formula
  desc "Super sed stream editor"
  # Original website is down: https://sed.sourceforge.io/grabbag/ssed/
  homepage "https://packages.debian.org/sid/ssed"
  url "http://deb.debian.org/debian/pool/main/s/ssed/ssed_3.62.orig.tar.gz"
  mirror "https://sed.sourceforge.io/grabbag/ssed/sed-3.62.tar.gz"
  sha256 "af7ff67e052efabf3fd07d967161c39db0480adc7c01f5100a1996fec60b8ec4"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?ssed[._-]v?(\d+(?:\.\d+)+)\.orig\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7f320800bb3b956cc9b1c04587ac2c93bf44dfea273107a9930a767bfa970f44"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "92006e68fb2c4e57950c340c9ccef34132c2577f7341b79c168ca906bd400018"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c90bd4517877eb2e72ed8ddfd9ebd830d781d10f3e1e21f81013ea76fc75816d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "145cb1b805276d6a61df5d706fac9e96cd1dd98f0e1e4f2a9bafe1af52fcef47"
    sha256 cellar: :any_skip_relocation, sonoma:        "fd6689f0fb272be1bf808fc7989f2c8d1223d684a76882e6f889f84f20642303"
    sha256 cellar: :any_skip_relocation, ventura:       "5bbc6dfa3c280d9cc26fe8d0516d0ce558cf1e81bdd546dc3ce897eb66f3c4f7"
    sha256                               arm64_linux:   "c8fc6e6bc3c579dfafeeaf205989db9d1048b345c30db3ef691593503ebcce17"
    sha256                               x86_64_linux:  "3c4df17253d6bc34e6b2d0df8fc7bc9034185a67701b9bf29bf4d5dafd3fe266"
  end

  def install
    # Fix compile with newer Clang
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1200

    args = %W[
      --mandir=#{man}
      --infodir=#{info}
      --program-prefix=s
    ]
    # Help old config scripts identify arm64 linux
    args << "--build=aarch64-unknown-linux-gnu" if OS.linux? && Hardware::CPU.arm? && Hardware::CPU.is_64_bit?

    system "./configure", *args, *std_configure_args
    system "make", "install"
    info.install info/"sed.info" => "ssed.info"
  end

  test do
    assert_equal "homebrew",
      pipe_output("#{bin}/ssed s/neyd/mebr/", "honeydew", 0).chomp
  end
end
