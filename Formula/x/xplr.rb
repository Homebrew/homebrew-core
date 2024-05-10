class Xplr < Formula
  desc "Hackable, minimal, fast TUI file explorer"
  homepage "https://github.com/sayanarijit/xplr"
  url "https://github.com/sayanarijit/xplr/archive/refs/tags/v0.21.8.tar.gz"
  sha256 "6fa6ab87cd9f48e531146e2f04c980f2ec90259b3e7b874bf9e165e613be0789"
  license "MIT"
  head "https://github.com/sayanarijit/xplr.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b068537d770244256f77020815603f54a667f20ea0334999fd3fef3bf4bf1ee1"
    sha256 cellar: :any,                 arm64_ventura:  "7a2a737789cda6265c86614b2298ddebe538759864d009fa86fc5da5c9c48f42"
    sha256 cellar: :any,                 arm64_monterey: "4cfac91c946191e32d77783d79d2ea37789ae33229d7b46deb2a4530f49bc1d1"
    sha256 cellar: :any,                 sonoma:         "a4f9dcaaa07ab5f5a17a30b64d0e28d612552a46bd2bafa61d5a1a722e75b6e9"
    sha256 cellar: :any,                 ventura:        "f9f27735dfd758e6422549484cc72fae852d24b2f9f9b5cc218ba6f16dab9074"
    sha256 cellar: :any,                 monterey:       "6b84f2f456fb888a03ec5ce9cd6c97c358507baae31c7550a8aedb7bb9a3b4f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f7910837bee5bc69efe2903fd4a2cce212bf208fdbf161ecf7573d9deb4d738f"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "luajit"

  def install
    system "cargo", "install", "--no-default-features", *std_cargo_args
  end

  def check_binary_linkage(binary, library)
    binary.dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == File.realpath(library)
    end
  end

  test do
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

    assert check_binary_linkage(bin/"xplr",
                                Formula["luajit"].opt_lib/shared_library("libluajit")),
           "No linkage with libluajit! Cargo is likely using a vendored version."
  end
end
