class Ttdl < Formula
  desc "Terminal Todo List Manager"
  homepage "https://github.com/VladimirMarkelov/ttdl"
  url "https://github.com/VladimirMarkelov/ttdl/archive/refs/tags/v3.8.0.tar.gz"
  sha256 "2b43db3c29d7aeb23dbb9b8f201d0e66d2860b9c23cb1d7161c853a2d8a0c5e1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "228478b7eb2faeea1533621bd66b9048b083d7d8669d286ea253fd85929ce376"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ccb0d2ee76890cf802ae2fa6d8e8f2348b092deaae7e476e006dc62ac19d3dfb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "33a1fbe59c589b9785c4c6cee313c7f944e19b67318a7da3c87cf4f0d872faa4"
    sha256 cellar: :any_skip_relocation, ventura:        "a138fe40f1ce20799b7ed826e5da9a720a4e3b6dc08060feb8298957e671efb6"
    sha256 cellar: :any_skip_relocation, monterey:       "d5fdf716c0cc364cc2a90b7e9616d20086fd9f18e45eaf59260e9bab5ad6a358"
    sha256 cellar: :any_skip_relocation, big_sur:        "d1694b3169e4f9395358ae34f876f6d7bb8f520d3a2f62484cb70e68fc62a327"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8220b6fa0172294ed05b8bcacfa43027e11348cdbabef6bde7f330938d6090fa"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Added todo", shell_output("#{bin}/ttdl 'add readme due:tomorrow'")
    assert_predicate testpath/"todo.txt", :exist?
    assert_match "add readme", shell_output("#{bin}/ttdl list")
  end
end
