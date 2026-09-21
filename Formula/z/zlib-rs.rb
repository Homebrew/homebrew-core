class ZlibRs < Formula
  desc "C API for zlib-rs"
  homepage "https://github.com/trifectatechfoundation/zlib-rs/tree/main/libz-rs-sys-cdylib#libz-rs-sys-cdylib"
  url "https://github.com/trifectatechfoundation/zlib-rs/archive/refs/tags/v0.6.8.tar.gz"
  sha256 "10c2faddc8f0f150a4917c9641f49e350cb4c1ce187962bc88e7f7ce1411837e"
  license "Zlib"
  head "https://github.com/trifectatechfoundation/zlib-rs.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "b55812598da1212a923cbc3f2ae0a21aa7a476e6a8b77b46c3051b363da16994"
    sha256 cellar: :any, arm64_tahoe:       "6f1b7590384f19467c52fa2871f7e9d418dea1f7d8cd42fb9f278c5c7ee91090"
    sha256 cellar: :any, arm64_sequoia:     "49b35291e790790cad24aae2251aad9f3553d362b3d3a4905fc7468c2d390a61"
    sha256 cellar: :any, arm64_linux:       "e4dd90a177b01e7ada61cb59ac46da99b56320e7b0f6b12d3241216646efafda"
    sha256 cellar: :any, x86_64_linux:      "db4ecf8e5d245e697e8d4d552eb3b889fa4ffd8493d5cb75f4e4785a087cdfee"
  end

  depends_on "cargo-c" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "zlib-ng-compat" => :test
  end

  def install
    # https://github.com/trifectatechfoundation/zlib-rs/tree/main/libz-rs-sys-cdylib#-cllvm-args-enable-dfa-jump-thread
    ENV.append_to_rustflags "-Cllvm-args=-enable-dfa-jump-thread"
    cd "libz-rs-sys-cdylib" do
      system "cargo", "cinstall", "--jobs", ENV.make_jobs.to_s, "--prefix", prefix, "--libdir", lib, "--release"
    end
  end

  test do
    # https://zlib.net/zlib_how.html
    resource "zpipe.c" do
      url "https://raw.githubusercontent.com/trifectatechfoundation/zlib-rs/refs/tags/v0.6.2/libz-rs-sys-cdylib/zpipe.c"
      sha256 "4fd3b0b41fb8da462d28da5b3e214cc6f4609205b38aaee1e20524b57124f338"
    end

    testpath.install resource("zpipe.c")
    ENV.append_to_cflags "-I#{formula_opt_include("zlib-ng-compat")}" if OS.linux?
    system ENV.cc, "zpipe.c", *ENV.cflags.to_s.split, "-L#{lib}", "-lz_rs", "-o", "zpipe"

    text = "Hello, Homebrew!"
    compressed = pipe_output("./zpipe", text, 0)
    assert_equal text, pipe_output("./zpipe -d", compressed, 0)
  end
end
