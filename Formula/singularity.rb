class Singularity < Formula
  desc "Application container and unprivileged sandbox platform for Linux"
  homepage "https://singularity.hpcng.org"
  url "https://github.com/hpcng/singularity/releases/download/v3.8.7/singularity-3.8.7.tar.gz"
  sha256 "3329f2e583f84a8343cb2c0380a1d6cbceafae7d1e633b5cbcadf7143eac859b"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "28682e7a4d9838c01e0caf9d675bf3cbf37a5cea66b7c8a2eda23291904bd755"
  end

  # No relocation, the localstatedir to find configs etc is compiled into the program
  pour_bottle? only_if: :default_prefix

  depends_on "go" => :build
  depends_on "openssl@1.1" => :build
  depends_on "pkg-config" => :build
  depends_on "libseccomp"
  depends_on :linux
  depends_on "squashfs"

  def install
    inreplace "pkg/util/singularityconf/config.go" do |s|
      unsquashfs_dir = Formula["squashfs"].bin.to_s
      s.sub!(/(directive:"mksquashfs path)/, "default:\"#{unsquashfs_dir}\" \\1")
    end
    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --without-suid
      -P release-stripped
      -v
    ]
    ENV.O0
    system "./mconfig", *args
    cd "./builddir" do
      system "make"
      system "make", "install"
    end
  end

  test do
    assert_match(/There are [0-9]+ container file/, shell_output("#{bin}/singularity cache list"))
    # This does not work inside older github runners, but for a simple quick check, run:
    # singularity exec library://alpine cat /etc/alpine-release
  end
end
