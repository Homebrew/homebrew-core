class Xplr < Formula
  desc "Hackable, minimal, fast TUI file explorer"
  homepage "https://github.com/sayanarijit/xplr"
  url "https://github.com/sayanarijit/xplr/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "6d766bc52c49782e3ca8ba7130f1cab95c69e42ff3c15eec2b0ac823ab7a36b3"
  license "MIT"
  head "https://github.com/sayanarijit/xplr.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4158e4d58b4114360c13aec3f9f2b2f89679dcfc9af1def273c1611404367479"
    sha256 cellar: :any,                 arm64_sequoia: "8e2af53ed70887dd5ff966adf2612259865c6db17c485ee9233dedf2f184df1b"
    sha256 cellar: :any,                 arm64_sonoma:  "c628e2c6d435b8765c2880dfe98dfbdd4a54705e04668d5aeac389bab23d6471"
    sha256 cellar: :any,                 arm64_ventura: "b1942b6c9b832b987ef777bf1454a805df69b3a5ef2a3be7771c3344a3fe5ba6"
    sha256 cellar: :any,                 sonoma:        "3792494258c3c05d1724666298be0ff8d9fa5f81fe3213b3a89419353f2cf920"
    sha256 cellar: :any,                 ventura:       "3cdb674789239cc18e01fd5d1863a3e4fd8f9510608706cc90d08402fca7080a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "940a502af128cb6dadf797a2cf6d4a6acc002bc4c9bbd3f4588a17a80069d0e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1c025d45df5cdf7e0a3a292d914745099b8a9854a4a61b8316aab72c32e7df22"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "luajit"

  def install
    system "cargo", "install", "--no-default-features", *std_cargo_args
  end

  test do
    require "utils/linkage"

    input, = Open3.popen2 "SHELL=/bin/sh script -q output.txt"
    input.puts "stty rows 80 cols 130"
    input.puts bin/"xplr"
    input.putc "q"
    input.puts "exit"

    sleep 5
    File.open(testpath/"output.txt", "r:ISO-8859-7") do |f|
      contents = f.read
      assert_match testpath.to_s, contents
    end

    assert Utils.binary_linked_to_library?(bin/"xplr",
                                Formula["luajit"].opt_lib/shared_library("libluajit")),
           "No linkage with libluajit! Cargo is likely using a vendored version."
  end
end
