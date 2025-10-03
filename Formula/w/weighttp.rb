class Weighttp < Formula
  desc "Webserver benchmarking tool that supports multithreading"
  homepage "https://redmine.lighttpd.net/projects/weighttp/wiki"
  url "https://github.com/lighttpd/weighttp/archive/refs/tags/weighttp-0.5.tar.gz"
  sha256 "5900600cc108041d0e38abd02354d7d3b14649c827c4266c0d550b87904f1141"
  license "MIT"
  head "https://git.lighttpd.net/lighttpd/weighttp.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5a9431eb7d71f87319baec3ba54e3d6e9bcb971d0356ed14928fb382593c1a9d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "747f42a474d5c96eb75aa6d3f26dd2871d4df6f4d81b183331fd884fa3494548"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ed5486cf450787db1c33a75595384abb0be250d3f7f1e72acca58f2a917dd653"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6598256aa773c154c7d1583f35350c8e79bda87113d10010560f026b4f71dbb8"
    sha256 cellar: :any_skip_relocation, sonoma:        "29aa4d4033b8d42c0d19775341bb677ed2ad36a76c63560b5f30f6c14a92a6e2"
    sha256 cellar: :any_skip_relocation, ventura:       "f8b15a0b7e333586d24a4b6dd1993bfa45b0b95a173b620210016e13aba538da"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9a163f9c93a97ef7facda6ceb7e353d18d4467bba6649c7ec5ea99659f53559c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "07a8f6aaec0a3cd34539dc74acb30d4ca3d392b70e1ca89342545ee7830aa343"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "libev"

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    # Stick with HTTP to avoid 'error: no ssl support yet'
    system bin/"weighttp", "-n", "1", "http://redmine.lighttpd.net/projects/weighttp/wiki"
  end
end
