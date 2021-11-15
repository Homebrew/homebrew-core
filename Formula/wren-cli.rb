class WrenCli < Formula
  desc "Simple REPL and CLI tool for running Wren scripts"
  homepage "https://github.com/wren-lang/wren-cli"
  url "https://github.com/wren-lang/wren-cli/archive/0.3.0.tar.gz"
  sha256 "a498d2ccb9a723e7163b4530efbaec389cc13e6baaf935e16cbd052a739b7265"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "417542b9c6d040b8cac7fdfacc034f8956afebfa8019145dbef51bb0d8b58038"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fe12f29f5ae858b05f3069d15c7245ff8126a08cea8e9521f877b7991409eafe"
    sha256 cellar: :any_skip_relocation, monterey:       "65cd437422c2c26054ed2fd6e6533009c5099abb24d559135351150edce53c67"
    sha256 cellar: :any_skip_relocation, big_sur:        "a24574abd51e1ddd58d41e2dbbd89fc0a85f27087541e1c9a982daa601bcdb39"
    sha256 cellar: :any_skip_relocation, catalina:       "bf9368948d1953ceef3246ff6e4d4d142b8d86d9d62d3f0f432a6f5d241f10b2"
    sha256 cellar: :any_skip_relocation, mojave:         "e11eb478ca480716c938c8f88af228bbdeaf394b6e11738606fbd57dff86a25d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "89cafae2a7e1fe07ae5a6b907e787dc2e4c5487992667c4b423e6ac7731c29f1"
  end

  def install
    if OS.mac?
      system "make", "-C", "projects/make.mac"
    else
      system "make", "-C", "projects/make"
    end
    bin.install "bin/wren_cli"
    pkgshare.install "example"
  end

  test do
    cp pkgshare/"example/hello.wren", testpath
    assert_equal "Hello, world!\n", shell_output("#{bin}/wren_cli hello.wren")
  end
end
