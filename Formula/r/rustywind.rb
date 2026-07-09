class Rustywind < Formula
  desc "CLI for organizing Tailwind CSS classes"
  homepage "https://github.com/avencera/rustywind"
  url "https://github.com/avencera/rustywind/archive/refs/tags/v0.25.2.tar.gz"
  sha256 "ba241018078f91c0760de084c5e54a3ac528bb2c5ec3241081ec7b130f68b645"
  license "Apache-2.0"
  head "https://github.com/avencera/rustywind.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b3271e59af74ffd3b3df89617dc744f49df17a3e2edd868de4bdfbd0bdd24546"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2e59a9ca3865035579bcd71c8bb8de5cb034b01ad7a523f5bcd9cc73ca317f83"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b082434ef7cd6a03f1cf0a943a44d3a155e97bbef0644384cc6efa340b75967b"
    sha256 cellar: :any_skip_relocation, sonoma:        "be77f3518273d2ef15d1547c7d24a2e98f892afcc715572b0a4180d3c6660486"
    sha256 cellar: :any,                 arm64_linux:   "3eb79528a33d214f99d763712096b061c2231455f2da9f418d2dcfc2bf53ec53"
    sha256 cellar: :any,                 x86_64_linux:  "ace2a7dbdd8327744b3542d81dcf540545e2949d8de085c7e27d5b816b8849a3"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "rustywind-cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rustywind --version")

    (testpath/"test.html").write <<~HTML
      <div class="text-center bg-red-500 text-white p-4">
        <p class="text-lg font-bold">Hello, World!</p>
      </div>
    HTML

    system bin/"rustywind", "--write", "test.html"

    expected_content = <<~HTML
      <div class="bg-red-500 p-4 text-center text-white">
        <p class="text-lg font-bold">Hello, World!</p>
      </div>
    HTML

    assert_equal expected_content, (testpath/"test.html").read
  end
end
