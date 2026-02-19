class Swiftdraw < Formula
  desc "Convert SVG into PDF, PNG, JPEG or SF Symbol"
  homepage "https://github.com/swhitty/SwiftDraw"
  url "https://github.com/swhitty/SwiftDraw/archive/refs/tags/0.26.0.tar.gz"
  sha256 "93aba794df81308d7a00a4054e76eba68d5d180d1f155627d61303ec7c3aa0df"
  license "Zlib"
  head "https://github.com/swhitty/SwiftDraw.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9df25c4d5a44596d1d4fb8ff43e1d8242abb0ff79953e89d8990b028c525b49d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "12e08b920cec7c20cfcf6f4c73f7883f4fe335bc8113594eac4879e43b4d5279"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "231324f73166cab91d3806de1e91b6487368b92ce43039ddbb8258b9b8f14c94"
    sha256 cellar: :any_skip_relocation, sonoma:        "9e9eaa5dd2bb72720e52d20d3256a3641c7ab8ae5ab48fc1590833b4eaef2a13"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d04eda6156c2d361cb6d29b97d2df4405ce791b7a72b538a0238a0934b35a460"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e6db783e67c35e05aed22b1b432c7da07a459c8096a2fbee67deacb1533d543e"
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
