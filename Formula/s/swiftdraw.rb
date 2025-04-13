class Swiftdraw < Formula
  desc "Convert SVG into PDF, PNG, JPEG or SF Symbol"
  homepage "https://github.com/swhitty/SwiftDraw"
  url "https://github.com/swhitty/SwiftDraw/archive/refs/tags/0.20.1.tar.gz"
  sha256 "d5038e5c981149e35833e36184f46513bdc674d54bbf654dabd1f7652e65b0be"
  license "Zlib"
  head "https://github.com/swhitty/SwiftDraw.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4869ad13a5fdcc4cd15dc2580dccdb0cfd522241f8274b2f01bed091a21a2fa6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0a3d5f52c7cb6799de670428827224b5d6211d2351efce81b211a8d10b5da8a6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "91bd59a30aeb7fb1e6af6e390f5701b2ffda06da4bda6d8273e2a7dd35b55e31"
    sha256 cellar: :any_skip_relocation, sonoma:        "ed4241cc3f3ab431d3d30957d00c954eeded179aa0fe2c41637f529363df1326"
    sha256 cellar: :any_skip_relocation, ventura:       "f946bb5e0d70c96afce333a694ce26289854738aaf58aad44139445af51a11b2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "12f53493f9ca52bdf5acd7fe1f6088935190872ef67bc4a4e533d2b4978e99bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5b3d8267a42cfaaf8672934c155384e033fdf1f6c87bdff6a5584af99b262a7e"
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
