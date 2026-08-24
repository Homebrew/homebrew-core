class Termframe < Formula
  desc "Terminal output SVG screenshot tool"
  homepage "https://github.com/pamburus/termframe"
  url "https://github.com/pamburus/termframe/archive/refs/tags/v0.8.7.tar.gz"
  sha256 "25d60c50c8f5022434ddd04ada7cd7334c61eb55efb735b052e1489e26293cde"
  license "MIT"
  head "https://github.com/pamburus/termframe.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e403dc07152616b319c38e5633352c94ee98979fe56de4b9d9f83156d4fdf5ff"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c4343edae5f77ca24075c08dbd30cbf369c390f97e911e16ffe413f2e2b52b9d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f5ccfe083cf5b7ccf3f01737bcbf1dc4babf5b87d792e96ab7dcb7b65c77a972"
    sha256 cellar: :any_skip_relocation, sonoma:        "a3536bd6ac77f00aedc17c69078ad5f14c81742c1cf82489343a5c415a4087c1"
    sha256 cellar: :any,                 arm64_linux:   "4bc8e21f8f9f1c0260cc28079c62a66ddd962364debab493a264dc00cbf00dd3"
    sha256 cellar: :any,                 x86_64_linux:  "72dbdaaf2b7eb23ac6f090df8c2dda8278feb641e9893b722e771b791c4a8714"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"termframe", "-o", "hello.svg", "--", "echo", "Hello, World"
    assert_path_exists testpath/"hello.svg"
  end
end
