class Zigup < Formula
  desc "Download and manage zig compilers"
  homepage "https://github.com/marler8997/zigup"
  url "https://github.com/marler8997/zigup/archive/refs/tags/v2025_05_24.tar.gz"
  sha256 "d88e6d9c9629c88aba78c3bae2fb89ae4bea11f2818911f6d5559e7e79bcae69"
  license "MIT-0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:[._]\d+)+)$/i)
    strategy :git do |tags, regex|
      tags.filter_map { |tag| tag[regex, 1]&.tr("_", ".") }
    end
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "50aaa33ea1e56a31d29c250dca2e9b0996a6d6ac61b80371dc29206764291574"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "775c5aa1aef28d3f2894d23725e54b6a34dd710c0eaae2d19cf9bb4aca2f6bf4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e917b9c89562ea0129c9b17120e4043aea935170d243a2c8f8ded2a18761960f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f6692ad6a0d59da6540e3da49f84c7ea37a10ed56009aab4a925d90a039aaf5b"
    sha256 cellar: :any_skip_relocation, sonoma:        "0e81b978cea25b90e8719244f50e0c4fca8aa4b7681154aaa864d2482f650337"
    sha256 cellar: :any_skip_relocation, ventura:       "af65106ea1dd8d3f526897bd1d15111773ef20a4ab1d9633a6882a1e825014bf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "452d30fb9c7f491fcfa34fb38b47f7b2134887bee6e5a5767e0a9a905030fe26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ec4689d639d16b0ddc595eeecf71a24209d8d91bd8a4ffbcdbe2b18e6025715a"
  end

  depends_on "zig@0.14" => :build

  def install
    # Fix illegal instruction errors when using bottles on older CPUs.
    # https://github.com/Homebrew/homebrew-core/issues/92282
    cpu = case Hardware.oldest_cpu
    when :arm_vortex_tempest then "apple_m1" # See `zig targets`.
    when :armv8 then "xgene1" # Closest to `-march=armv8-a`
    else Hardware.oldest_cpu
    end

    args = %W[
      --prefix #{prefix}
      --summary all
      -fno-rosetta
    ]
    args << "-Dcpu=#{cpu}" if build.bottle?
    system "zig", "build", *args
  end

  test do
    system bin/"zigup", "fetch-index"
    assert_match "install directory", shell_output("#{bin}/zigup list 2>&1")
  end
end
