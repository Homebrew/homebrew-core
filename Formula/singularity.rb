class Singularity < Formula
  desc "Application container and unprivileged sandbox platform for Linux"
  homepage "https://singularity.hpcng.org"
  url "https://github.com/hpcng/singularity/releases/download/v3.8.2/singularity-3.8.2.tar.gz"
  sha256 "996611dec402b4d372b8b9456dd9ec1cb43712d08502e455f38521bd199856d3"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "565338bfa4b430b4e3de41de908e91b225e98fdcba64db857f2aedfc1c782be2"
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
