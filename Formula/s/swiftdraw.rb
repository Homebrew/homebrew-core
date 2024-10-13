class Swiftdraw < Formula
  desc "Convert SVG into PDF, PNG, JPEG or SF Symbol"
  homepage "https://github.com/swhitty/SwiftDraw"
  url "https://github.com/swhitty/SwiftDraw/archive/refs/tags/0.17.0.tar.gz"
  sha256 "94aadc284bf38cd175db7acef629238c9904888a60034caee079a8ba66d7bc2d"
  license "Zlib"
  head "https://github.com/swhitty/SwiftDraw.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "439c5f604af6b35a46edba0cac51baee9bc12e752124241cf251c3c5119b3444"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dc01a6046468e8fd903e2f08fe3a2687cde18f5d03e5bf847f05ebef7a304d42"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f8d8e05b1ce9102549188ce5e97fceda9d360c6f9d091418734a20d7d5d66d32"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f6821bb2deefc08fc6bd6fc7826273c60c11cde9f300b3735431d9d1a9e74868"
    sha256 cellar: :any_skip_relocation, sonoma:         "298e7fd736eeb890278ceef9f056fff50b008adfd40647557ce250c8d64e3673"
    sha256 cellar: :any_skip_relocation, ventura:        "db466e712512c8690f9c39d97bff7ffc722bbd4c38defe3ab5ff2e4ff26ce4f7"
    sha256 cellar: :any_skip_relocation, monterey:       "2ab63a7ed1af568165fb8913b36656d797d5bdb6a86bd9da4fb77b45d2f67c77"
    sha256                               x86_64_linux:   "8cfba61afbfb7d85eb3c6298d3dd97dbdad6af278a8e9cdb7d86e1c938bb872c"
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
