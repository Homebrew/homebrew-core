class Xwin < Formula
  desc "Microsoft CRT and Windows SDK headers and libraries loader"
  homepage "https://github.com/Jake-Shadle/xwin"
  url "https://github.com/Jake-Shadle/xwin/archive/refs/tags/0.5.1.tar.gz"
  sha256 "9de51db9439e4ede2666152107f9ba9668aa1de7fffe418933c6be7eff315f90"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1231792c92c68bc0e4c3b179100bb36c7a42777f12974646356ea9460036c085"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "92b98e80683eca545a0e78d1373034c75246674cd8d011275511bbffde788265"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "526630b8297fc9c30b5a8097fb7e844a0bfe66629d400270bf70b5ab75a8f9b8"
    sha256 cellar: :any_skip_relocation, sonoma:         "0791fcfba79d92843ba824f1e8d23cebb2ccc804376ec80568d148c9d5f7b408"
    sha256 cellar: :any_skip_relocation, ventura:        "8533548dec49c0d035634672be43079672f97d6c6c666d490ab52d3df3c1c2b1"
    sha256 cellar: :any_skip_relocation, monterey:       "7bc74558f69b94899ae5527c12736f049e5c6b1c663dfa404b9c92f80cf9d998"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e75f3146f112fb4ae20242390f6dd1bb20dfdc08a198b47da23bdd18779a84f2"
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
