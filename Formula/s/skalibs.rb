class Skalibs < Formula
  desc "Skarnet's library collection"
  homepage "https://skarnet.org/software/skalibs/"
  url "https://skarnet.org/software/skalibs/skalibs-2.14.4.0.tar.gz"
  sha256 "0e626261848cc920738f92fd50a24c14b21e30306dfed97b8435369f4bae00a5"
  license "ISC"
  head "git://git.skarnet.org/skalibs.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b0b1cb92fd1402d94ae6077cfb98b9ced6a4a8ff78cae0928aa853b63964a139"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c668db63e78d6fc7ebe695706f1d26081db734729bdb6892f783d128b8943291"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "43990849b9d5f38a0a33a6dc0f25b4ee9ff409507a88e1e6128e4667a1b3713a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "01857e93e5a8a2704431e7c6b2ace60186c31b81c43f1d6c47fd3fd52076367b"
    sha256 cellar: :any_skip_relocation, sonoma:        "a3fe1ab96abe85ef7adfb3171a518adcd560fcab2e9cb0b6f94bad4234f9c159"
    sha256 cellar: :any_skip_relocation, ventura:       "d2c4b2975ac522a649ed12b2d5274adf349b742ba2ec340b26856fd599184097"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b8b80b464e01b3bee02137e71cbcdc44003ebede2c435a4ee267358044588ea9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d45e63d528bb32ffe845bcfcacf39d8e52809c0975273aa51a2dd324fea60c5d"
  end

  def install
    # Shared libraries are linux targets and not supported on macOS.
    args = %w[
      --disable-silent-rules
      --disable-shared
      --enable-pkgconfig
    ]
    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <skalibs/skalibs.h>
      int main() {
        return 0;
      }
    C
    system ENV.cc, "test.c", "-L#{lib}", "-lskarnet", "-o", "test"
    system "./test"
  end
end
