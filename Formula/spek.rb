class Spek < Formula
  desc "Acoustic spectrum analyser"
  homepage "https://www.spek.cc"
  url "https://github.com/alexkay/spek/releases/download/v0.8.5/spek-0.8.5.tar.xz"
  sha256 "1bccf85a14a01af8f2f30476cbad004e8bf6031f500e562bbe5bbd1e5eb16c59"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "86675392f6f5a6ef0678fbf46924a7dacb688e527c69bde9af332a59c6679d0e"
    sha256 cellar: :any,                 arm64_monterey: "d6df033b0ab8875c8679e5193a2bdc9f660cbe9c652f66fc60b30f5b03a93dce"
    sha256 cellar: :any,                 arm64_big_sur:  "ed7a768fdd3a7e71b741cf1ccc74dc4d38b75ce51dda388d7f34d8a5e6640a78"
    sha256 cellar: :any,                 ventura:        "c7497d09dc179fddca4548834a60e0210d2600167741a707c0a9771977f9b1b1"
    sha256 cellar: :any,                 monterey:       "fa3cfdf04d333186c6f9d182dfc252b542dc5f404f48d0d72a76d786c0bd5af8"
    sha256 cellar: :any,                 big_sur:        "49dc0f6ec1fd74ab89d29229307d6c5107d1fd4f2a1004395a0e6dbe2696b394"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "65d0a8fdf69183d1d6ff08d907d5cb370017529c7697d34036ac1faa03854baa"
  end

  depends_on "pkg-config" => :build
  depends_on "ffmpeg"
  depends_on "wxwidgets"

  def install
    args = std_configure_args - ["--disable-debug"]
    system "./configure", *args, "--disable-silent-rules"
    system "make"

    # https://github.com/alexkay/spek/issues/235
    cp "data/spek.desktop.in", "data/spek.desktop" if OS.linux?

    system "make", "install"
  end

  test do
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"].present?

    assert_match "Spek version #{version}", shell_output("#{bin}/spek --version")
  end
end
