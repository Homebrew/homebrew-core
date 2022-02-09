class Svgbob < Formula
  desc "Convert your ascii diagram scribbles into happy little SVG"
  homepage "https://ivanceras.github.io/svgbob-editor/"
  url "https://github.com/ivanceras/svgbob/archive/0.6.3.tar.gz"
  sha256 "f8a1ab5058391e399defa062527c04773c04157a754f5a5fc0f3f2cfe53e46eb"
  license "Apache-2.0"
  head "https://github.com/ivanceras/svgbob.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cdb8dd2fee492985a829ccd9c6288d1419ff4718e83baa4101547eb275f5f739"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "63cf389bd247b74ced834f020f754f6c45ad86642cd281f40097c087bd94b5f5"
    sha256 cellar: :any_skip_relocation, monterey:       "9e236e3d163f494da2f1e3159b1aad2576ca9dce5c5d769d308202a54fbe6b65"
    sha256 cellar: :any_skip_relocation, big_sur:        "107988d17b94a867fc4b3ae1f2dd506bb6afe054275d26958a9655b028da46e5"
    sha256 cellar: :any_skip_relocation, catalina:       "a2536db9cadca9137f57ed22a687ed60ee691ff476070070473f0e4a109126b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d82aae54e36ad8f62762b4185065fd4f8b661d92eeeb32642f19c47657706523"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "packages/cli")
    # The cli tool was renamed (0.6.2 -> 0.6.3)
    # Create a symlink to not break compatibility
    bin.install_symlink bin/"svgbob_cli" => "svgbob"
  end

  test do
    (testpath/"ascii.txt").write <<~EOS
      +------------------+
      |                  |
      |  Hello Homebrew  |
      |                  |
      +------------------+
    EOS

    system bin/"svgbob", "ascii.txt", "-o", "out.svg"
    contents = (testpath/"out.svg").read
    assert_match %r{<text.*?>Hello</text>}, contents
    assert_match %r{<text.*?>Homebrew</text>}, contents
  end
end
