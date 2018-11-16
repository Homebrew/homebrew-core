class Stgit < Formula
  desc "Push/pop utility built on top of Git"
  homepage "https://github.com/ctmarinas/stgit"
  url "https://github.com/ctmarinas/stgit/archive/v0.19.tar.gz"
  sha256 "746f043c8a7caf5e675ef9d5c894a4a0a7d581ad4244747512f5efcccfbac5ff"
  head "https://github.com/ctmarinas/stgit.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "93befd3ca1f31141139803efff2369ae20e9cbcbd58f662bf56f6ce9361f569f" => :mojave
    sha256 "cf5d28fd456e9d28a4dae935ce96968cfa019801381e9d4ba50ed978d42fe791" => :high_sierra
    sha256 "0eee6dda264e8d497079d734b3127dbc84931a831edcb488a6ea55f80cc1cce5" => :sierra
    sha256 "0eee6dda264e8d497079d734b3127dbc84931a831edcb488a6ea55f80cc1cce5" => :el_capitan
    sha256 "0eee6dda264e8d497079d734b3127dbc84931a831edcb488a6ea55f80cc1cce5" => :yosemite
  end

  def install
    ENV["PYTHON"] = "python" # overrides 'python2' built into makefile
    system "make", "prefix=#{prefix}", "all"
    system "make", "prefix=#{prefix}", "install"
  end

  test do
    system "git", "init"
    (testpath/"test").write "test"
    system "git", "add", "test"
    system "git", "commit", "--message", "Initial commit", "test"
    system "#{bin}/stg", "init"
    system "#{bin}/stg", "log"
  end
end
