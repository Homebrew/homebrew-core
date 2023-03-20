class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.51.2.tar.gz"
  sha256 "179183919dbde1f6bdb46f7799641ef0fefc29aa9ab31e52d7efb6ffe01f72ac"
  license "MIT"
  head "https://github.com/nicklockwood/SwiftFormat.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "16165bcbcc50d595066d0a382314612c2e499399f23c93bee908fd929d68f54c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "48b326f8bc6da3f61f221011bd615a3f7c65de9f42514c3f40c132f4513e066e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9bf579d284c187c7697f2666b6c54cea447915be206c14098043d18e56800232"
    sha256 cellar: :any_skip_relocation, ventura:        "05f7613a4c1fd4e7b8219354b7192f0f876d22c22a11a9d4846c900fcfdf3c48"
    sha256 cellar: :any_skip_relocation, monterey:       "cdf4e5908e76a83f80aeecfa4519a61d5466f711b41142125bf86123bf95be85"
    sha256 cellar: :any_skip_relocation, big_sur:        "6e8ae67963422df1eb9ed8851d7777f2d1681b4b0f238a6ed8633166701f03d8"
    sha256                               x86_64_linux:   "b8e17b0cf8acba072c321e38d758efb3c8933049890e3ae94a594317a5e81246"
  end

  depends_on xcode: ["10.1", :build]

  uses_from_macos "swift"

  def install
    system "swift", "build", "--disable-sandbox", "--configuration", "release"
    bin.install ".build/release/swiftformat"
  end

  test do
    (testpath/"potato.swift").write <<~EOS
      struct Potato {
        let baked: Bool
      }
    EOS
    system "#{bin}/swiftformat", "#{testpath}/potato.swift"
  end
end
