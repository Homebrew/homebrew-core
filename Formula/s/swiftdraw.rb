class Swiftdraw < Formula
  desc "Convert SVG into PDF, PNG, JPEG or SF Symbol"
  homepage "https://github.com/swhitty/SwiftDraw"
  url "https://github.com/swhitty/SwiftDraw/archive/refs/tags/0.25.0.tar.gz"
  sha256 "9dd257d38089e919176d6b19d2ebff569845c11090744d8a9a2e2dfb4f4034d1"
  license "Zlib"
  head "https://github.com/swhitty/SwiftDraw.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "310fc09194f68bbdeb74d1fd50f424b70a1e14bc532ac216140ce610b885b00c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "95fed74462bb075e0e30bf29fc06bb3f6364981d281fd17f6299913d4479b98b"
    sha256 cellar: :any_skip_relocation, sonoma:        "c9636b7a0ce4d0497de2c9ae6cc43b9b6362a26ef97a1c3fcc55fe6b995027b0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "773e7ce797377b42991b29d3a8e6f62fb0893d5ce6b0729b177f16ff776855d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "460447f88c076f723fbf8f486dfa230b00e79fcb5e551c7c885225d6fea71b82"
  end

  depends_on xcode: ["16.0", :build]

  uses_from_macos "swift" => :build
  uses_from_macos "libxml2"

  def install
    args = if OS.mac?
      ["--disable-sandbox"]
    else
      ["--static-swift-stdlib"]
    end
    system "swift", "build", *args, "--configuration", "release"
    bin.install ".build/release/swiftdrawcli" => "swiftdraw"
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
