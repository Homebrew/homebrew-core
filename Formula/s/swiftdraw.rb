class Swiftdraw < Formula
  desc "Convert SVG into PDF, PNG, JPEG or SF Symbol"
  homepage "https://github.com/swhitty/SwiftDraw"
  url "https://github.com/swhitty/SwiftDraw/archive/refs/tags/0.25.3.tar.gz"
  sha256 "8f7d0d70f1bd2bdd383408a1da8db77eb02a8482fc56690dbfe86a125cde2e10"
  license "Zlib"
  head "https://github.com/swhitty/SwiftDraw.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3f40b9bf9914a5af2343e0dd67d223abadb9962fc12ae78c5ced8d9e096ffc0d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "71752c19d8902acbec986bc393ac6d99691eb7dce80b9c79813304592eaf954b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e579fc0b8772875a38407d30cc40664640777dd9fc3f15b82e2cf5e1fed0981a"
    sha256 cellar: :any_skip_relocation, sonoma:        "c1f20563700469e1441c5683494cf9f3554e37509168e8bae176c3a15e5fe361"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e61333fcee618029ba81a1f7e9a0ec8a7007d615a729b6e1a99033dc96fd7a52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3802f2421ba9d4f9c0698e77ba1051ae568147489882625362535e5ab71b0583"
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
