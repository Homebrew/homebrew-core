class Ultralist < Formula
  desc "Simple GTD-style task management for the command-line"
  homepage "https://ultralist.io"
  url "https://github.com/ultralist/ultralist/archive/0.9.3.tar.gz"
  sha256 "34273de7c1a46db4ba4a94c9d7f9ffd4cb9d5498dcb9379906565f6bb5f7c796"

  bottle do
    cellar :any_skip_relocation
    sha256 "716b2d4f39ddc41aeddeff419454fce764d0bdad6eeced76e1fb3a42e75f26e0" => :mojave
    sha256 "cc5d2192153e416785293d9db8a4af6379c5e2385a78e02d58eb74d68316f8f9" => :high_sierra
    sha256 "c343ff19e0fb099fc13b5110425a4bab7d495cf7467297acaf860250a27f9697" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/ultralist/").mkpath
    ln_s buildpath, buildpath/"src/github.com/ultralist/ultralist"
    system "go", "build", "-o", bin/"ultralist", "./src/github.com/ultralist/ultralist"
  end

  test do
    system bin/"ultralist", "init"
    assert_predicate testpath/".todos.json", :exist?
    add_task = shell_output("#{bin}/ultralist add learn the Tango")
    assert_match /Todo.* added/, add_task
  end
end
