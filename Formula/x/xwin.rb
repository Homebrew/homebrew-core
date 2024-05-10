class Xwin < Formula
  desc "Microsoft CRT and Windows SDK headers and libraries loader"
  homepage "https://github.com/Jake-Shadle/xwin"
  url "https://github.com/Jake-Shadle/xwin/archive/refs/tags/0.5.2.tar.gz"
  sha256 "96f58c79e87a3ebf8c9b707907c6f2cb915958704761e2a22c377ed730ccb0e3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f96cb5a40565d3f43907ebd24d35dac831ef34562cf7692f8054f6fa188ba50a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "55155e28fa925f0e494ab480f436e86123fa868b6594e8ef1b869ff91c4b80ef"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "36ae2b24c79b2c68bf6e7de4a260e7609e04807bd5b6176b8cf6e9f11d574615"
    sha256 cellar: :any_skip_relocation, sonoma:         "3c487a21b85e6ed259e5c96977182875a426f58d33f92168b6a229003695faec"
    sha256 cellar: :any_skip_relocation, ventura:        "fdf8cfa107faf2293a83e5be8a6e554042e1315db96b734a746ece9193001ad7"
    sha256 cellar: :any_skip_relocation, monterey:       "71d838871ff5146aea1236cc06d9c3c6e10b557d5dad34e312e30acfe4fe42f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cf81d6dbfc9be751a8eb42abd26f0479706d7d8084a699db339095ba4a05244f"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"xwin", "--accept-license", "splat", "--disable-symlinks"
    assert_predicate testpath/".xwin-cache/splat", :exist?
  end
end
