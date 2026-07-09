class Swiftdraw < Formula
  desc "Convert SVG into PDF, PNG, JPEG or SF Symbol"
  homepage "https://github.com/swhitty/SwiftDraw"
  url "https://github.com/swhitty/SwiftDraw/archive/refs/tags/0.28.0.tar.gz"
  sha256 "ac660bc69f2c25154e67b9e65f8b54327860ad51b194ef59c74a7142fb6099f9"
  license "Zlib"
  head "https://github.com/swhitty/SwiftDraw.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3099f01ead2ee0a83b3030b73dd5f061c386ebf2c95f721b90007081b30e1d29"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eed009e37accfa1b3720f83e6879f42b08bd2858af2a503448b650c4cb120a33"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "72599bda1b9eac0bc22ac64a9ee82af14cf8faed6d107b8b5d76920e8f237ef0"
    sha256 cellar: :any_skip_relocation, sonoma:        "04298f49a77471cc4a00d69cff8670384b263040b8520e4c781fe6ee537ecdf4"
    sha256 cellar: :any,                 arm64_linux:   "46dbf757ad2f29a12b4b9405f22810acb718904300c2ce2e029477ea0fa383d3"
    sha256 cellar: :any,                 x86_64_linux:  "130bacfa737a0e1783cf5471dda07b4e299a4132a87d8e34b5b12a9368f21672"
  end

  depends_on xcode: ["16.0", :build]

  uses_from_macos "swift" => :build
  uses_from_macos "libxml2"

  def install
    args = if OS.mac?
      ["--disable-sandbox"]
    else
      ["--static-swift-stdlib", "-Xswiftc", "-use-ld=ld"]
    end
    system "swift", "build", *args, "--configuration", "release"
    bin.install ".build/release/swiftdrawcli" => "swiftdraw"
  end

  test do
    (testpath/"fish.svg").write <<~SVG
      <?xml version="1.0" encoding="utf-8"?>
      <svg version="1.1" xmlns="http://www.w3.org/2000/svg" width="160" height="160">
        <path d="m 80 20 a 50 50 0 1 0 50 50 h -50 z" fill="pink" stroke="black" stroke-width="2" transform="rotate(45, 80, 80)"/>
      </svg>
    SVG
    system bin/"swiftdraw", testpath/"fish.svg", "--format", "sfsymbol"
    assert_path_exists testpath/"fish-symbol.svg"
  end
end
