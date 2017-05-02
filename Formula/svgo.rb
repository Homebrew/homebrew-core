require "language/node"

class Svgo < Formula
  desc "Nodejs-based tool for optimizing SVG vector graphics files"
  homepage "https://github.com/svg/svgo"
  url "https://github.com/svg/svgo/archive/v0.7.2.tar.gz"
  sha256 "93b36477366e6b48b9bc3f9086232ae7fc16b87fa36acc1d524720ea58123fcf"

  bottle do
    cellar :any_skip_relocation
    sha256 "3a6ed7e647e164bf54be07b8ec30826fb4cad3893f98526113704974cc3065a6" => :sierra
    sha256 "cab94f5d68e5b7077d416faf40a1cfb331bf9e2fea214ba6332b962b38534f17" => :el_capitan
    sha256 "507ad3f9c0d5ab79d5a1adb11161d2e7f5aa05f2c9a170bab72720ef8bf94759" => :yosemite
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    cp test_fixtures("test.svg"), testpath
    system bin/"svgo", "test.svg", "test.min.svg"
    assert_match /^<svg /, (testpath/"test.min.svg").read
  end
end
