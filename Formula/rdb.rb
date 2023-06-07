class Rdb < Formula
  desc "Redis RDB parser"
  homepage "https://github.com/HDT3213/rdb/"
  url "https://github.com/HDT3213/rdb/archive/refs/tags/v1.0.9.tar.gz"
  sha256 "7b123989ea855ffc8e11220d45d0705e385e13079165626a634bc6572dc12827"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2af956af20238a40064705d6bfcb72a80af7d77cd1f5e51af56a494f94e7d78d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2af956af20238a40064705d6bfcb72a80af7d77cd1f5e51af56a494f94e7d78d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2af956af20238a40064705d6bfcb72a80af7d77cd1f5e51af56a494f94e7d78d"
    sha256 cellar: :any_skip_relocation, ventura:        "38db522a16e426a40fe589d4ee8ed7f9f77e06b8c7b01a2e441bcda05193a1c8"
    sha256 cellar: :any_skip_relocation, monterey:       "38db522a16e426a40fe589d4ee8ed7f9f77e06b8c7b01a2e441bcda05193a1c8"
    sha256 cellar: :any_skip_relocation, big_sur:        "38db522a16e426a40fe589d4ee8ed7f9f77e06b8c7b01a2e441bcda05193a1c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0f1118877970b5c4effb4ebff4a910edccaaccd42a2ece32d8f6333cc057bd74"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
    pkgshare.install "cases"
  end

  test do
    cp_r pkgshare/"cases", testpath
    system bin/"rdb", "-c", "memory", "-o", testpath/"mem1.csv", testpath/"cases/memory.rdb"
    assert_match "0,hash,hash,131,131B,2,ziplist,", (testpath/"mem1.csv").read
  end
end
