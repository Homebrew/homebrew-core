class Xlsclients < Formula
  desc "List client applications running on a display"
  homepage "https://gitlab.freedesktop.org/xorg/app/xlsclients"
  url "https://www.x.org/archive/individual/app/xlsclients-1.1.5.tar.xz"
  sha256 "68baee57e70250ac4a7759fb78221831f97d88bc8e51dcc2e64eb3f8ca56bae3"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7845c576ced4a3065eac6aa6d86619c19650b8f1d894f3ab3ec954ba14697b33"
    sha256 cellar: :any,                 arm64_sequoia: "f232c88f33a86c8c9c4f660d5b1102f7a91f26d9b9565d41e6a1bbd5e282b3d2"
    sha256 cellar: :any,                 arm64_sonoma:  "be45e2812020b6a380b6c7affa69859d6563e79087308382ef6b30cc6bdaae1a"
    sha256 cellar: :any,                 arm64_ventura: "e9cab1de3e8ebc016baf33dddca3a6846c1f97b2cb5092f1e2124e45761adf2d"
    sha256 cellar: :any,                 sonoma:        "022fdaa226764ac119faa1a3a7fb00a48e6551100dce9557e217fb6f815a640c"
    sha256 cellar: :any,                 ventura:       "8883d8f93bacc5461d48d9a0cc979699582eea0ac790c0a84ae2a7106718d852"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "43acf15e78b649f48c13d8d9b44bd427ccd1e2f8b7943f73b1103c3aff5ccdb5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fdb67879482e31bc17326a25a77645f1ccf875f7455bd29d12f8b16f41fd7453"
  end

  depends_on "pkgconf" => :build
  depends_on "libxcb"

  def install
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/xlsclients -display :100 2>&1", 1)
    assert_match "xlsclients:  unable to open display", output
  end
end
