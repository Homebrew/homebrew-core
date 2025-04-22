class Swiftdraw < Formula
  desc "Convert SVG into PDF, PNG, JPEG or SF Symbol"
  homepage "https://github.com/swhitty/SwiftDraw"
  url "https://github.com/swhitty/SwiftDraw/archive/refs/tags/0.21.0.tar.gz"
  sha256 "83a08fc68cbae050b9c484b18ffb2909fbd774281625c5509fd0ec8127f8c813"
  license "Zlib"
  head "https://github.com/swhitty/SwiftDraw.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1a872ae45c421eafb9a62cc714b330f375ced3d4737bd863d5e5ad645a9f354e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "21c321c6f4c37bb855ec175f09001312abcb0fcd1749be70e7653a181769e9eb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dda0c33168a03d5dccfada5f8fb669c697133623d83a7cdaa63737c858e6e76d"
    sha256 cellar: :any_skip_relocation, sonoma:        "6a4c303d2b68b336eb314a5f7a9248c4e611c5d2f2aa131c0e8930dcd17e419e"
    sha256 cellar: :any_skip_relocation, ventura:       "ab3896fc065157dc90733ae61ae943634bc9b4b5752c57b14e448310cf947712"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dc101a3672ff884df44e0f7b5df98c8d49cd60e20c8fada2bb44dbcfc853bd17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "013026aa86eac3c83513a342fa7208c08a4831915e6c954de0e441ee47dc907c"
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
