class S6Rc < Formula
  desc "Process supervision suite"
  homepage "https://skarnet.org/software/s6-rc/"
  url "https://skarnet.org/software/s6-rc/s6-rc-0.6.0.0.tar.gz"
  sha256 "46d4a62959ef16097b84dcfb0c3b31a6ff49aa476d4aeec9c5b7bde1ce684901"
  license "ISC"
  head "git://git.skarnet.org/s6-rc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fe87f78bdf90ce4b333fd938fefe7ddb83610d5ff56c8702379423aabb9e2aeb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "39fa8c4fd1944a64087eacc799ea396508625794c30eb57967254aedf64438d7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cfe09771cd716edaf7cf5f4823e5f6445aacfc4e44702daed550c0069007c3b8"
    sha256 cellar: :any_skip_relocation, sonoma:        "cb335b14006884fa6f1767bde6055e9d8999fcd9be783c766482828b197daf53"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "89222f77047fe7d4830bf67744275a0d3b068e7cadf713e21fb84f791d535ee6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "86e2c5dd3090eb3b36a5c0d40b22f677337f4256a97c5118d0c34d5b7f2882fb"
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
