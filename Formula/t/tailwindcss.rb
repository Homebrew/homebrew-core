class Tailwindcss < Formula
  desc "Utility-first CSS framework"
  homepage "https://tailwindcss.com"
  url "https://github.com/tailwindlabs/tailwindcss/archive/refs/tags/v3.4.10.tar.gz"
  sha256 "40410b3225e169a6c7b81fb8a562f0784a70c785161cd3b8f38ad0c47c403fbc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "08073f377bc9852f16974c904cf2c887eafb34575e7e0564b1b742e97e7778fa"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d3a92bd0334db66ce1c64bcdbc2fc3b2218146244e1aa1b5b47fdf22114b43e9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d3a92bd0334db66ce1c64bcdbc2fc3b2218146244e1aa1b5b47fdf22114b43e9"
    sha256 cellar: :any_skip_relocation, sonoma:         "f2078a3d5e378cb97245a6e5281c8d4a3e597d1594df588f68c7544b8a1ab43f"
    sha256 cellar: :any_skip_relocation, ventura:        "dc18836746b963df84b4aebb84e9ca56e05822a3c41c71f66b936383f9ba61a1"
    sha256 cellar: :any_skip_relocation, monterey:       "dc18836746b963df84b4aebb84e9ca56e05822a3c41c71f66b936383f9ba61a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fdcc4ddfc54e20ab49e5bf11fae9c075a99cadd4584ca112f8b7f0ce83441eae"
  end

  depends_on "node" => :build

  def install
    system "npm", "install", *std_npm_args(prefix: false)
    system "npm", "run", "build"

    cd "standalone-cli" do
      system "npm", "install", *std_npm_args(prefix: false)
      system "npm", "run", "build"
      os = OS.mac? ? "macos" : "linux"
      cpu = Hardware::CPU.arm? ? "arm64" : "x64"
      bin.install "dist/tailwindcss-#{os}-#{cpu}" => "tailwindcss"
    end
  end

  test do
    (testpath/"input.css").write("@tailwind base;")
    system bin/"tailwindcss", "-i", "input.css", "-o", "output.css"
    assert_predicate testpath/"output.css", :exist?
  end
end
