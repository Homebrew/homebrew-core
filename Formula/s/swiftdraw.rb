class Swiftdraw < Formula
  desc "Convert SVG into PDF, PNG, JPEG or SF Symbol"
  homepage "https://github.com/swhitty/SwiftDraw"
  url "https://github.com/swhitty/SwiftDraw/archive/refs/tags/0.22.0.tar.gz"
  sha256 "072f68d7dc5481fb4139b5f437db6a388014deb34ae11eefd8729de565f431f7"
  license "Zlib"
  head "https://github.com/swhitty/SwiftDraw.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "61ff66d69af1b5609c53920d90af27958a03e67f16f3e4b92a93a59102c9da3d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c2275cd577cce39b7994b86ebabc7c44a08be2ab9b8318f3b49fff6abaf06b99"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6487967882b8a29a17eddedb99f49c6e57faaee1893caf65c3141b9005e961f7"
    sha256 cellar: :any_skip_relocation, sonoma:        "d58f4d73ff88f049f4eca9ac1125bcafe83d8f22a1e66eeb3caa0f0e6074cc51"
    sha256 cellar: :any_skip_relocation, ventura:       "937236fcaf02b73ce585afcdd7b4cbb8ef61f941a09788f15c74c38d29457878"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fea9f4155e962b4ac717e93ae699f1c040930f68f20381179f774b99c45538cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e1621b92bbfeeb8f795667b0c406ea2647e12b0af0dfbc3ec656a314710fc6a"
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
