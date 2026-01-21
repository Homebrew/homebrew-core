class S6Rc < Formula
  desc "Process supervision suite"
  homepage "https://skarnet.org/software/s6-rc/"
  url "https://skarnet.org/software/s6-rc/s6-rc-0.5.6.0.tar.gz"
  sha256 "81277f6805e8d999ad295bf9140a909943b687ffcfb5aa3c4efd84b1a574586e"
  license "ISC"
  head "git://git.skarnet.org/s6-rc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "352840f345c351dc4bc9e2d29f18bd95dfe5b7669b71afe2f16cf1f85975ca0f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ffb8c25c6c698f13c255d694dfc6218116857cf633b6764a6ee4c026de314e20"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "120ab3b0a9ca7cf2db5f0b27ee6dffcebb3560e718956f5cab8693655d9aac14"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "06402eee4fafa9c0bcdbcce7dcd88054b9f142263a8ce6019ee1ec54b534beb3"
    sha256 cellar: :any_skip_relocation, sonoma:        "66888c1bab3552b773e18e694b52ce22bc525d343cdaf3622fded2921832c642"
    sha256 cellar: :any_skip_relocation, ventura:       "486096d10e4ce41f00e27aa5d62d30c9acab44c539542db7ac34afc36ac25571"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e84a61c37b4988f98170ca737ea6b2fc95720619bb07253ea1e1a4d45233e36a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "26be7908d0ae2d584614d6aefe7b4bc4ffc1b45dce5743b801f416fdf5310282"
  end

  depends_on "pkgconf" => :build
  depends_on "execline"
  depends_on "s6"
  depends_on "skalibs"

  def install
    # Shared libraries are linux targets and not supported on macOS.
    args = %W[
      --disable-silent-rules
      --disable-shared
      --enable-pkgconfig
      --with-pkgconfig=#{Formula["pkgconf"].opt_bin}/pkg-config
      --with-sysdeps=#{Formula["skalibs"].opt_lib}/skalibs/sysdeps
    ]
    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"services/test").mkpath
    (testpath/"services/test/up").write <<~SHELL
      #!/bin/sh
      echo "test"
    SHELL
    (testpath/"services/test/type").write "oneshot"
    (testpath/"services/bundle/contents.d").mkpath
    (testpath/"services/bundle/type").write "bundle"
    touch testpath/"services/bundle/contents.d/test"
    system bin/"s6-rc-compile", testpath/"compiled", testpath/"services"
  end
end
