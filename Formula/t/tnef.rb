class Tnef < Formula
  desc "Microsoft MS-TNEF attachment unpacker"
  homepage "https://github.com/verdammelt/tnef"
  url "https://github.com/verdammelt/tnef/archive/refs/tags/1.5.0.tar.gz"
  sha256 "f148885bf3282845fe110575cc8dbb73983ed83c07b40a44bf5a8ac629b14378"
  license "GPL-2.0-or-later"

  bottle do
    manifest_sha256 "ca50ec62d9a54871684273ccbfeaa67f131ee74e7462237e36e7fe92847b48e8"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "37ea3716f28fa08540bcc9b5f392d76f9b75150d336bfc647f072a07d6bf4397"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b2a3da05be728448c575afe5cb90f10076eda11b13249c9545b6ee3f7f8a79a7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "587454e192168e610baa1e87448b34a653de74738fbcb73462aeb37c6fca8113"
    sha256 cellar: :any,                 arm64_linux:       "cadc930992f2b7b921adb9d158f6e80dcb30f53d465eea1cf9856ec527555645"
    sha256 cellar: :any,                 x86_64_linux:      "9f8b0a41a08ffc22c106bf49b67b04390f2c8b78b70206065641d544f4fe5458"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  deny_network_access!

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"tnef", "--version"
  end
end
