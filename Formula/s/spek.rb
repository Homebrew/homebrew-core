class Spek < Formula
  desc "Acoustic spectrum analyser"
  homepage "https://www.spek.cc"
  url "https://github.com/alexkay/spek/releases/download/v0.8.5/spek-0.8.5.tar.xz"
  sha256 "1bccf85a14a01af8f2f30476cbad004e8bf6031f500e562bbe5bbd1e5eb16c59"
  license "GPL-3.0-or-later"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a434f5f525998ad4de94e89af65453dab86c371546d1b0468a799a77ba22f445"
    sha256 cellar: :any,                 arm64_ventura:  "4da941a0a603896fd2c7c9bbf6a2fc111fff0378e04471d9ef4d1b6932212790"
    sha256 cellar: :any,                 arm64_monterey: "09a5c514d629a475c0f27c2899719a27a3e84db8d93304f568a15b8aed03fa0f"
    sha256 cellar: :any,                 sonoma:         "e4d77fc4a259cf4d864eeb0059cc27e203b49ba2459fb251e237b2f8c7412f30"
    sha256 cellar: :any,                 ventura:        "0282680357860d5b083421f330ec203c9eb3d223c9d478c53a93818db2c679f7"
    sha256 cellar: :any,                 monterey:       "b94b801a93e392bc91cc055991fd7cedd92bdd77be291fded38ca9b7317d8f8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "73d782e38ee8b6b90ed44ad6a7e91e58f2c0f37f8822793888aa1d60870b9df5"
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
