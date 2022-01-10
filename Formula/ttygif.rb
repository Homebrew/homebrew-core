class Ttygif < Formula
  desc "Converts a ttyrec file into gif files"
  homepage "https://github.com/icholy/ttygif"
  url "https://github.com/icholy/ttygif/archive/1.6.0.tar.gz"
  sha256 "050b9e86f98fb790a2925cea6148f82f95808d707735b2650f3856cb6f53e0ae"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c2c31ef2caaf2c5dcb9ee96fd19267f93c4a3e8376e9d44e21686bdede507d85"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c24b1c9714124e4e36eb799ef832ed4e1cd1264dd92c131d235df7cb47dbf10b"
    sha256 cellar: :any_skip_relocation, monterey:       "4efc5dee59ad2f3dcdde5e6397272f5799a132691a2c3cfddc801963546cb61a"
    sha256 cellar: :any_skip_relocation, big_sur:        "10887e22e06da0d22817453166f442d619e28058e505d981b159dcf70b20e74a"
    sha256 cellar: :any_skip_relocation, catalina:       "61f7135b9f03465ac86f26e7b7cad7ca09ec35495841ee868b76f001faefd040"
    sha256 cellar: :any_skip_relocation, mojave:         "34060f2f53d6388461ca29a81938490bb1768aa9f44303c7cce717c2f8ad6246"
    sha256 cellar: :any_skip_relocation, high_sierra:    "ab8ee96836d9a9663e94f9dc9e2337a2968a8fe4523f8da166b4e865a1e81ada"
  end

  depends_on "imagemagick"
  depends_on "ttyrec"

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    ENV["TERM_PROGRAM"] = "Something"
    system "#{bin}/ttygif", "--version"
  end
end
