class S6Rc < Formula
  desc "Process supervision suite"
  homepage "https://skarnet.org/software/s6-rc/"
  url "https://skarnet.org/software/s6-rc/s6-rc-0.7.0.0.tar.gz"
  sha256 "bf5b8ce0da5a4ee70d642b818b61d9916a7a9b64a457595f388113e54a188688"
  license "ISC"
  head "git://git.skarnet.org/s6-rc.git", branch: "main"

  bottle do
    sha256 arm64_tahoe:   "5bce3c4ba5c3c59242327cab64197f850d15232b6c4366fc33e015c0feafcf69"
    sha256 arm64_sequoia: "553fc882211d7f9e463c5f639821ceebf03a2e3ae8d12432259316cbcd4b6f7c"
    sha256 arm64_sonoma:  "e5c98782feffbfdd64b09af1979a545b4fe06a4fa8876a13fe11f6e0ed35da14"
    sha256 sonoma:        "c3efb17b4f104b8ed5f503a12b91e52ff97e0403f09850285b095c480ce8f5eb"
    sha256 arm64_linux:   "198ff684a3b37c0511e25879d50bf673a8ff9dd12f874abe297607c8292f5e52"
    sha256 x86_64_linux:  "b47a98a8a88dfd777d98a67201a023d92602b333cf6992db87629b7e32a7cc26"
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
      --with-pkgconfig=#{formula_opt_bin("pkgconf")}/pkg-config
      --with-sysdeps=#{formula_opt_lib("skalibs")}/skalibs/sysdeps
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
