class Swiftdraw < Formula
  desc "Convert SVG into PDF, PNG, JPEG or SF Symbol"
  homepage "https://github.com/swhitty/SwiftDraw"
  url "https://github.com/swhitty/SwiftDraw/archive/refs/tags/0.25.1.tar.gz"
  sha256 "7016b9a8a035cd6a87d72bbfadba168948b5e1f069bb922ca1419b1122aff254"
  license "Zlib"
  head "https://github.com/swhitty/SwiftDraw.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aa1295db70d1e5b108046d1ac7cb801a15a6826742a970c7d190271d2e2b9e68"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4bdb212c2771659678ea1f8cd22339979a55f76561a4547c2fd5efc6e67d2f1a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4fd64178cf70a769b2fa0ccf6d634a806df91914a300721f638366b1ef6a444a"
    sha256 cellar: :any_skip_relocation, sonoma:        "2183ae401419163d66ff0f130932055e75d2d5888deee422fe2a991afcccd497"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2e2f257dddeaca7757183a77908aadee70fab1b3ab4472c7ffc762436a12f37a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "efdb31d71154865519ab8c0b65c9eab8d54fc1df13d05c50b605d982528b4c98"
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
