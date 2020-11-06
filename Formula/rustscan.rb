class Rustscan < Formula
  desc "Modern Day Portscanner"
  homepage "https://github.com/rustscan/rustscan"
  url "https://github.com/RustScan/RustScan/archive/2.0.1.tar.gz"
  sha256 "1d458cb081cbed2db38472ff33f9546a6640632148b4396bd12f0229ca9de7eb"
  license "GPL-3.0-or-later"

  bottle do
    cellar :any_skip_relocation
    sha256 "ca3a6b433c7af7e02e8ea675b80c03d8577e9de9c9a6d4ddad38e37dd7a39686" => :catalina
    sha256 "ac8f4deb1c01a009c35b76967b382f74fd8210f7cde110473fa173c6a6f12754" => :mojave
    sha256 "39f2f461961fb15896d9380d504ca02bc4d869a44dc409fe67dcfb921f15bd9b" => :high_sierra
  end

  depends_on "rust" => :build
  depends_on "nmap"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_no_match /panic/, shell_output("#{bin}/rustscan --greppable -a 127.0.0.1")
    assert_no_match /panic/, shell_output("#{bin}/rustscan --greppable -a 0.0.0.0")
  end
end
