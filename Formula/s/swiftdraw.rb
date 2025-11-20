class Swiftdraw < Formula
  desc "Convert SVG into PDF, PNG, JPEG or SF Symbol"
  homepage "https://github.com/swhitty/SwiftDraw"
  url "https://github.com/swhitty/SwiftDraw/archive/refs/tags/0.25.1.tar.gz"
  sha256 "7016b9a8a035cd6a87d72bbfadba168948b5e1f069bb922ca1419b1122aff254"
  license "Zlib"
  revision 1
  head "https://github.com/swhitty/SwiftDraw.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ec3e3aebc3996bb571223a757e11f2fddacf662e93701cd2f3d9b85683943b2a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bb040ba456d2a75ddb91b7da57b9519f979c4ce9e571c580ef6d83bdcff82cb0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "445c518fc6191a15fc2984ad9603c0d7fba1fc0a99ebdfe9db663890e4bcc2b0"
    sha256 cellar: :any_skip_relocation, sonoma:        "f686245c63c61b376eac4919b3c61280d285161f09f0134b22726eee837df8e6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "266ef70e02afe0f6cd66f0db1aeb961d5b6dd91b5909df5b51e7dfb5d6a56075"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "21cb3dfc2ba88064d86aa40e128de025d0434e016554bab5ea28ad96e528cddc"
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
