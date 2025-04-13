class Xplr < Formula
  desc "Hackable, minimal, fast TUI file explorer"
  homepage "https://github.com/sayanarijit/xplr"
  url "https://github.com/sayanarijit/xplr/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "72e9b53552b4fce61805c32c739d8d7db4723f80b4586c9eb5e9921e1ae32ce0"
  license "MIT"
  head "https://github.com/sayanarijit/xplr.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d0e94ec68f4de399d20267cb847e859594ad550edceb378797fa005eda5fba5d"
    sha256 cellar: :any,                 arm64_sonoma:  "8d14184eb28e3c9e4aad281d8bd86bdaefc76f1ccc9153e97211b3cf71b3e604"
    sha256 cellar: :any,                 arm64_ventura: "7629449d18d25d39455dcff74f2746c8531292f709116dad4701673627039a65"
    sha256 cellar: :any,                 sonoma:        "11b427f5313b5a86ae5007553903eb1702f3f73cecfd33f044a79c64a79a2fbc"
    sha256 cellar: :any,                 ventura:       "255db6ba076943720b3500a46d51e9985c1abe09095edb74d13e8a90c746fbe7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f8b97ff3140ef328d4dc330c7082c1d0bffdb61555d04aaef779fac7552da2f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5fb6dcaa884f339e2b63da4a7b1284f8619e778f32eb459c09f6bb56a761da57"
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
