class Tengo < Formula
  desc "Fast script language for Go"
  homepage "https://tengolang.com"
  url "https://github.com/d5/tengo/archive/v2.13.0.tar.gz"
  sha256 "675251439cff5a1b06c44376c3106c370fe11ac7b2b38f75c75890565c5929a9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "99fd933bd106844175aa0cb56de47b4eecbb3cea8bd4c48d495e456b075053c3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "99fd933bd106844175aa0cb56de47b4eecbb3cea8bd4c48d495e456b075053c3"
    sha256 cellar: :any_skip_relocation, monterey:       "2b647f2bf248604428658316ec6a17efea849b2b65577ae534a5760e75ef3e7e"
    sha256 cellar: :any_skip_relocation, big_sur:        "2b647f2bf248604428658316ec6a17efea849b2b65577ae534a5760e75ef3e7e"
    sha256 cellar: :any_skip_relocation, catalina:       "2b647f2bf248604428658316ec6a17efea849b2b65577ae534a5760e75ef3e7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b060b525a0baf70dd5955251a6db83ced4f8afa146b7e4889096eefb7eab9ef3"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/tengo"
  end

  test do
    (testpath/"main.tengo").write <<~EOS
      fmt := import("fmt")

      each := func(seq, fn) {
          for x in seq { fn(x) }
      }

      sum := func(init, seq) {
          each(seq, func(x) { init += x })
          return init
      }

      fmt.println(sum(0, [1, 2, 3]))   // "6"
      fmt.println(sum("", [1, 2, 3]))  // "123"
    EOS
    assert_equal shell_output("#{bin}/tengo #{testpath}/main.tengo"), "6\n123\n"
  end
end
