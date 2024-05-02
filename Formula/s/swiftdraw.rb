class Swiftdraw < Formula
  desc "Convert SVG into PDF, PNG, JPEG or SF Symbol"
  homepage "https://github.com/swhitty/SwiftDraw"
  url "https://github.com/swhitty/SwiftDraw/archive/refs/tags/0.16.2.tar.gz"
  sha256 "bd2c5e770363276efb2c6c9f84decaca61327026069758ea08b2a73c28736a7b"
  license "Zlib"
  head "https://github.com/swhitty/SwiftDraw.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "94f3e84835305d03f7b9f41b31508d5460d49dbb5972e21895d861cfdd1b55ea"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7d8ba4caea041ece400915dc6d882c0fc2a36c2e6af592634c72c34bebaee793"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a898e4c5557b07c61d1377f9d84e63c577317670ffd61ebea3e3c8d8843b469d"
    sha256 cellar: :any_skip_relocation, sonoma:         "3d9fb2b865c6bd32131d248ef6678532df4fc7e37fc84b8f445c47ce595686e7"
    sha256 cellar: :any_skip_relocation, ventura:        "7b559aeaa50f4b9fe5a45a1647e7b7e9003225443f3233933c4a5bb2ac439709"
    sha256 cellar: :any_skip_relocation, monterey:       "2231502e890e31b32a461f1c81b6c8e895fbb29500ccce4170d26febd217c311"
    sha256                               x86_64_linux:   "f14a4b0a2aaf6b87e843b6812cc98acc1be9bd320b8029f0c22a2acc3f3bd3d8"
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
