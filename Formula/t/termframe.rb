class Termframe < Formula
  desc "Terminal output SVG screenshot tool"
  homepage "https://github.com/pamburus/termframe"
  url "https://github.com/pamburus/termframe/archive/refs/tags/v0.10.3.tar.gz"
  sha256 "094f6510f2bd456da9fbf41c00eb323d1ef14a61bac786f9c9f71c59ed90bd57"
  license "MIT"
  head "https://github.com/pamburus/termframe.git", branch: "main"

  bottle do
    manifest_sha256 "0ec6b49944ab0a9bb61051b434dedf94004ea723e1cb7908aea2e1930cab4a08"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "676d924f08b67eb168b101fbeb1ccdaa846862bd42b2734f49c0ec75dffafb7c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7c19424f5c78f35c87ff93b02e4df823850c85356eaf7b0ec7a5741437a1a7fb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "080ff0fab5d11ce0966c316a0404a513bb18aac70be1c8d2b653735b6ef23e26"
    sha256 cellar: :any,                 arm64_linux:       "552995c02fe050d91f9cdd53171bea521ce969dc5545b1579d151e66fe7a1677"
    sha256 cellar: :any,                 x86_64_linux:      "e9cfeb17e12548782ded7148de338a8feb7c7f33e95a605d42baa9f56511c272"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  # `test do` block downloads fonts.
  allow_network_access! :test

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"termframe", "-o", "hello.svg", "--", "echo", "Hello, World"
    assert_path_exists testpath/"hello.svg"
  end
end
