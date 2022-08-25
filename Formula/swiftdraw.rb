class Swiftdraw < Formula
  desc "Convert SVG into PDF, PNG, JPEG or SF Symbol"
  homepage "https://github.com/swhitty/SwiftDraw"
  url "https://github.com/swhitty/SwiftDraw/archive/0.13.0.tar.gz"
  sha256 "f36db04508de74e3da57a10f732bc889f1cfb23bf7bb99e9e0086108cd6ac26f"
  license "Zlib"
  head "https://github.com/swhitty/SwiftDraw.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "588f526b2a36b9898a14f08fbe216cd2b8bf9735c5b17590891759f3d633a391"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "76bfaf3c223b0af3bfa23198dfe0f05add4bca3cc26d3099484a080fdbd4a24b"
    sha256 cellar: :any_skip_relocation, monterey:       "d57f3fd0d05222ad0a47d9f883a8bb9fdafb1930e3086b768350024deaf4e9b1"
    sha256 cellar: :any_skip_relocation, big_sur:        "b44c12f1c81d7683679ccab50a2fae04c0bd1fa3452ddec59ae4cd02dfd8c2ff"
    sha256                               x86_64_linux:   "4525f4ea0b710777e87508961025e882e49a4356e49fe12d2f1f4e4d4a3e98c4"
  end

  depends_on xcode: ["12.5", :build]
  uses_from_macos "swift"

  def install
    system "swift", "build", "--disable-sandbox", "--configuration", "release"
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
