class Xwin < Formula
  desc "Microsoft CRT and Windows SDK headers and libraries loader"
  homepage "https://github.com/Jake-Shadle/xwin"
  url "https://github.com/Jake-Shadle/xwin/archive/refs/tags/0.2.13.tar.gz"
  sha256 "c368cb6d4fc510d0c2bb06cfe8a63266f9ee06016e281b5afae6b6adba66bb89"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "65c5a40f81c344ee63888039d6291efab27770ba00c5aba601dba46be64eb7e8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0723eabc793a59065ed16ff63bfd8759054cfbc5d7e7be707affa0bc0560c04e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c99d198b719519a89062ebc55e3cc461f9420feae5b1217e0e9e8ffe10846f1a"
    sha256 cellar: :any_skip_relocation, ventura:        "01f22805dae32be45b04e3a226a10c74bf797a35c17bcdccfa607859985e9c3c"
    sha256 cellar: :any_skip_relocation, monterey:       "985faf477acf21e01cb71e7e0a05de7a547056750c7a88dde10ef2933f0ed355"
    sha256 cellar: :any_skip_relocation, big_sur:        "1ef9ef22b275f90f5a9edac27c5e261245d08af5be25aae0d0605635de214337"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3c4cb679655e6744ab24028cc7b978400840caa699c4dbee5bb818a787d6785e"
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
