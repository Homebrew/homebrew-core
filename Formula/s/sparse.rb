class Sparse < Formula
  desc "Static C code analysis tool"
  homepage "https://sparse.wiki.kernel.org/"
  url "https://mirrors.edge.kernel.org/pub/software/devel/sparse/dist/sparse-0.6.4.tar.xz"
  sha256 "6ab28b4991bc6aedbd73550291360aa6ab3df41f59206a9bde9690208a6e387c"
  license "MIT"
  head "https://git.kernel.org/pub/scm/devel/sparse/sparse.git", branch: "master"

  livecheck do
    url "https://mirrors.edge.kernel.org/pub/software/devel/sparse/dist/"
    regex(/href=.*?sparse[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "1812b2141b6a73fa59159ad4600fad73eced788c86121bada4c764f33c0d279f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "56f5a3f7e3acbbd57f46ef1bf435a2a5130d719dd9f28e3578eabe79097aef3a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b4bf9baccb8ffe407b9f59f8933d72d4676e08adbeffcd4f3dcea9c3b0db9ca5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c1c53b9ca28fe2ce54ff72f0f9642289704ccae97868a2a90e2cb02095e8d7df"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3afb8b9256e015fcb1fc49608cea9fe6c02e6a93fa1df0a7720a30c5e8057699"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "57f40e26e5b3c4239c2f247705d3b6b27256482ef67c239cb34bc82ec5cea891"
    sha256 cellar: :any_skip_relocation, sonoma:         "06d1f2a6ccf48df9c8d8dcc96d38cc9007adccf537fbd1517fdb2d7ff8681bb1"
    sha256 cellar: :any_skip_relocation, ventura:        "0f5139fcf069d80d6ac94c12904b9f46dd5066b24619dacef6ca3c34442730fe"
    sha256 cellar: :any_skip_relocation, monterey:       "7c86940a523d15f63966df796fdea74176c02be7adc8c4071d2f60a194bd30af"
    sha256 cellar: :any_skip_relocation, big_sur:        "c858bb88d9f4d2d00da1d7498ee130a6d134b77a07d786d9b3906b74fedc90b0"
    sha256 cellar: :any_skip_relocation, catalina:       "a1517973190e2b8fdf21136344334ad757a0bd4fe24ab65c0846a4e5e64b26df"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "0c108dfd45b36b234fc6962ccf1b3f027185e34a904abcc162575d4e7e480b41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8c282a77e53c828abe22a69af0b1dd9cb124b333344f9be1b0f0f3d0a55a3fb0"
  end

  def install
    # BSD "install" does not understand the GNU -D flag.
    # Create the parent directories ourselves.
    inreplace "Makefile", "install -D", "install"
    bin.mkpath
    man1.mkpath

    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"test.C").write("int main(int a) {return a;}\n")
    system bin/"sparse", testpath/"test.C"
  end
end
