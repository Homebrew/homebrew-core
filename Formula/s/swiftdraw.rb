class Swiftdraw < Formula
  desc "Convert SVG into PDF, PNG, JPEG or SF Symbol"
  homepage "https://github.com/swhitty/SwiftDraw"
  url "https://github.com/swhitty/SwiftDraw/archive/refs/tags/0.18.1.tar.gz"
  sha256 "31eecfbf68e5045e4a87311fc864f59e61ef1c1de028f168cc9ded7c463a7b1f"
  license "Zlib"
  head "https://github.com/swhitty/SwiftDraw.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8b063792a90ee42fe8b98afecb90f497a921506f66a59d3d6c9ec9fdebd088f0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6faa5a04c98a8576561e58106dffa192e5674bb7968787ea79ab43bcf16dd508"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1a90b94e47ccdf0918b48c27a92f1da6a770c2664a404abdf5d93e1f6453f122"
    sha256 cellar: :any_skip_relocation, sonoma:        "818620df9562b2920fe1ec3d2e2682798cd504dedbca5869e4647fc04ff93951"
    sha256 cellar: :any_skip_relocation, ventura:       "2206434dace062363e1a2f1aca1b48abe23bab49b2fc4731a00db15bf81ab552"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ad72752a14c21b3465db45b752eb743b35a6c735e3b35f0a6611c46d3091569e"
  end

  depends_on xcode: ["14.0", :build]

  uses_from_macos "swift" => :build
  uses_from_macos "libxml2"

  def install
    args = if OS.mac?
      ["--disable-sandbox"]
    else
      ["--static-swift-stdlib"]
    end
    system "swift", "build", *args, "--configuration", "release"
    bin.install ".build/release/swiftdraw"
  end

  test do
    (testpath/"fish.svg").write <<~EOS
      <?xml version="1.0" encoding="utf-8"?>
      <svg version="1.1" xmlns="http://www.w3.org/2000/svg" width="160" height="160">
        <path d="m 80 20 a 50 50 0 1 0 50 50 h -50 z" fill="pink" stroke="black" stroke-width="2" transform="rotate(45, 80, 80)"/>
      </svg>
    EOS
    system bin/"swiftdraw", testpath/"fish.svg", "--format", "sfsymbol"
    assert_path_exists testpath/"fish-symbol.svg"
  end
end
