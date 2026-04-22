class Readsb < Formula
  desc "ADS-B decoder swiss knife"
  homepage "https://github.com/wiedehopf/readsb"
  url "https://github.com/wiedehopf/readsb/archive/refs/tags/v3.16.11.tar.gz"
  sha256 "ac0488a2deadd20b373a56928b7d297b5e9262566dd84ec9c72cffaedff2cc78"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6cea77bd2ae08e406436388a50817887bd2ff9c761ad65dcd91d6b32c666accd"
    sha256 cellar: :any,                 arm64_sequoia: "d68b8680399a387f90120829405827c283dddec3ac93ad9002a8da666212db10"
    sha256 cellar: :any,                 arm64_sonoma:  "4d38d478e3d512e884f07c8c06a6a6adf608374e8570a489958dd682b86d404e"
    sha256 cellar: :any,                 sonoma:        "1e41575b2996a26ffb30ae568c7254d95105c7eec32e2bf0292a20ac3163e595"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "14fd510cee6c10d45a3eeecb5f7efcbc23433e902d56c367473f5a8807a752f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a4ef10b822578813c7a0309ce39796e5741c32e6983f135fcc323d7fc079f5b1"
  end

  depends_on "pkgconf" => :build
  depends_on "librtlsdr"
  depends_on "zstd"

  uses_from_macos "ncurses"

  on_macos do
    depends_on "libusb"
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  # Fix to error: use of undeclared identifier 'MADV_HUGEPAGE'
  # Issue ref: https://github.com/wiedehopf/readsb/issues/128
  patch do
    url "https://github.com/wiedehopf/readsb/commit/6d31c983c6dd19c49b3ae95292155e5a9c7840f9.patch?full_index=1"
    sha256 "916ce4fee223f24fcc0e0825ebc80c44d6e8978a06e6efec7ebbf86f4fa59f20"
  end

  def install
    ENV["RTLSDR"] = "yes"
    system "make"
    bin.install "readsb"
  end

  test do
    require "base64"

    enc = <<~EOS
      goB/en99g4B9gH6Eg35/fICVhJl/gXx9f4F+f36Af4B/f3+AgH9+f39/gH+Af4CBf4F/f3
      9/f3+AgIGAgH9/f4F/gX9/gH+Bf4B/f3+Af4F+f359gX5/f36BgYB9fIeGm46Ig3p+mIGYfX19f
      oGFf4B/gIGAf3+AgoR8dHVle3iBhH98fn6AgIB+gIB/gIF/f4F+gYCAf3+AfoB/fX6CgICAen6K
      i5WQhIF6foOBgYB9g454lW6CfH2Cg36AgYCBgX6Af4CAf4B/gICAf39/gICAf39/gICAf35/f4B
      /f35+fn6Af4B/f4B/gIB+f35+gX+BfoF/f39/fYF/fIGDgYF/aHttfISAgIB9gYGBfn6AgIF8fn
      6DlIaXgYF+fn+Df3+AgH+Cf4CAgH+Af4CAf4B+f4CAgH9+f39/foGCgH9xbG1wf4KDgHl/hIGCf
      mSIc4mYfJB9jHSUb4N+e36CgYCCfmp/a3p1cmh3dYGHf39+foCAfX9+gIF9cIddm2ybhIV/e3qZ
      gqyBkYiJjZSHipOJlYp9fIN+pn+ncol3eoGJd5lgjVt+eoCEe2V3aHt5Z2RfY3R8bntjen6BgYB
      hiFmZc46FeXuMd5x/iX+Siq2PmH17hoWUk42GkoGVgpF7k3yOd49wjnSGbIdrhHB8Z3xwfHBsWG
      Vlf4N/gGR4bXlwg2eIdoJpkFyfd417jHWdg4h+eYSal6qNkIyFk42PhZaAkYOOeplyhnl3fpBvm
      FeEYn6Ff3x4ZHlydnNjYmNwfIN/gGN9UYVli4CBfH1mk2OmeZmDfnuFhqaQpIaIjoyWkYF+f32d
      h6t7knV7got4lGmEd4hsi1CAaXx5dGR4dYOGcXFncn2CgoF7gH+Cf4F+f4CAf4GAgYF/gH+AgIB
      /f39/gIF+gH1/f3+Af4CAfoB+f39/gYB/fn5+gIB+fX5+gIJ+e4CCf4F+XYpcjnmGcJBxk4N9fI
      R7qIiphox+fIWLm52kkoh/fIGXgJd7iH2dbKBkhXaHb4tkfn1+gX1fa1VzcoeFdnhlc3R8bXxQh
      mOMg395hmySdo97knuTgI6CkYWTiZKKkJCKkYiPh5iBkn+Pfqhvn2t9gYB9jGaHcIBwfGZ/dHNp
      ZFpzc3N5Y3N3gYOAY39TkGuSgoB8f22ecqp8joKOhp5+hYF8kJOPjZKAlIeQg5d5kX6PeKJnlmy
      Bc4hshW18a4BrfXBwaXVzhIVxdVJvY311gGSGb4WFfHOMbZd7iXiYfa6Dk354hYqNloyKkIiRiJ
      J/k4CRfpVyj3mNdplbj2aAd4Njgm19hnlwdWdxd21zbnRufWw=
    EOS

    (testpath/"input.bin").write Base64.decode64(enc)
    assert_match "ICAO Address:", shell_output("#{bin}/readsb --device-type ifile --ifile input.bin 2>/dev/null", 1)
  end
end
