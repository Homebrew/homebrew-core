class Redstore < Formula
  desc "Lightweight RDF triplestore powered by Redland"
  homepage "https://www.aelius.com/njh/redstore/"
  url "https://www.aelius.com/njh/redstore/redstore-0.5.4.tar.gz"
  sha256 "58bd65fda388ab401e6adc3672d7a9c511e439d94774fcc5a1ef6db79c748141"
  license "GPL-3.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?redstore[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "b4f7cfae26c26edf74952a959d8e56b8058ee755bd4384a18089257af330623a"
    sha256 cellar: :any,                 arm64_sequoia:  "722eb9bb530ade0f251ce260bc4f0dc3b519b164e86d2c3792d6559edfd1f01e"
    sha256 cellar: :any,                 arm64_sonoma:   "17d341618995c10bb92327af09bc2af0fb295fc798fb229b5813db72e912f639"
    sha256 cellar: :any,                 arm64_ventura:  "55306289261abde9b677d1906bb58420dc0bd3a52b775c3257ccb80c5ba04cdb"
    sha256 cellar: :any,                 arm64_monterey: "6043b778fa8d393eb0505eca982e0f2dcba99354aa3c6bba9d1042de6425bac7"
    sha256 cellar: :any,                 arm64_big_sur:  "03952d80ba4b35e0a1a7a85a9ae9fe56e9e31bd6e2797729c28ffee377ee2fcf"
    sha256 cellar: :any,                 sonoma:         "12fca2f939d2fe399dcff87f87ac6a2d0dc4448d4d2d2577faa5182681dd0e4d"
    sha256 cellar: :any,                 ventura:        "840637ec24ca832cad462cfbe3fa6f8693ccf86c5e74edeeccab5e12a3573633"
    sha256 cellar: :any,                 monterey:       "1ae97b18f1cb08f3872712accb48942d7c992a76f4dddae0b7a6566d22f40ec5"
    sha256 cellar: :any,                 big_sur:        "fa44b96b71ff73060973893222eb264f18c54f8c64ebb73c903eef2e544868ee"
    sha256 cellar: :any,                 catalina:       "f473645a1903ac48caf0bea886c13636ca093c4ca6f57f83ce9ffc4864f88ee5"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "67a498c2f25e82a164b7d5191d8824ca398c2ad7f774eb6971de1855a7712122"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f459a58381dd6067d033bb20eb4101af9136f5260796bd2daee07cf6365c3bde"
  end

  depends_on "pkgconf" => :build
  depends_on "raptor"
  depends_on "rasqal"
  depends_on "redland"

  def install
    # Fix compile with newer Clang
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

    ENV.append "CFLAGS", "-D_GNU_SOURCE" unless OS.mac?

    args = []
    # Help old config scripts identify arm64 linux
    args << "--build=aarch64-unknown-linux-gnu" if OS.linux? && Hardware::CPU.arm? && Hardware::CPU.is_64_bit?

    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/redstore --help 2>&1", 1)
    assert_match "RedStore version #{version}", output
  end
end
