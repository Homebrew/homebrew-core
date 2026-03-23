class S6 < Formula
  desc "Small & secure supervision software suite"
  homepage "https://skarnet.org/software/s6/"
  url "https://skarnet.org/software/s6/s6-2.14.0.1.tar.gz"
  sha256 "c25afe817cbc3f594efc5050351f8b9101ba78616d0ce915658f370e7ee2e258"
  license "ISC"
  head "git://git.skarnet.org/s6.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e95cfad8adbf092855ba5944124b102614af34d54a2e230705079e5ff40fc24c"
    sha256 cellar: :any,                 arm64_sequoia: "7e72f87cb7e627ea5daffcb99e58033ed7f3d5f7f497c846c771a08534686fa5"
    sha256 cellar: :any,                 arm64_sonoma:  "d5c73ceed74c1069faa28fb477e82156187fbb0eefacf90bb0cac9dfdc15c5f5"
    sha256 cellar: :any,                 sonoma:        "864fbc30f870d4a8558093e66f1dc61cb80bfd824bcc532a288cb0b64c7a085b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0982099a11389c9d3f4d38985de2c070f8c88b1ddc6b7b38e218a0791b7e55e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f1fd2a0f981c7fac694786821beedb20d65b697c486fe6b3d2f575a53ef1334d"
  end

  depends_on "pkgconf" => :build
  depends_on "execline"
  depends_on "skalibs"

  def install
    args = %W[
      --disable-silent-rules
      --enable-shared
      --enable-pkgconfig
      --with-pkgconfig=#{Formula["pkgconf"].opt_bin}/pkg-config
      --with-sysdeps=#{Formula["skalibs"].opt_lib}/skalibs/sysdeps
    ]
    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"log").mkpath
    pipe_output("#{bin}/s6-log #{testpath}/log", "Test input\n", 0)
    assert_equal "Test input\n", File.read(testpath/"log/current")
  end
end
