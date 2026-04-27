class Vlang < Formula
  desc "V programming language"
  homepage "https://vlang.io"
  # NOTE: Keep this in sync with V compiler below when updating
  url "https://github.com/vlang/v/archive/refs/tags/0.5.1.tar.gz"
  sha256 "444f20a77b57fec8a4e8a31fb2d50c318d277fe8377e0c870c2087395c0de810"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256                               arm64_tahoe:   "cc874e4768a2864b7e11fdc979890cf1d43523e5ff6a782b47f201754970bd20"
    sha256                               arm64_sequoia: "d76b8e73e5b582a058176d6f12191e7abc7f2b4abe1c34bc394aebe3d8a3204a"
    sha256                               arm64_sonoma:  "5bfe1fc97d00ead3636fb5a1bbe1eb86ea64675ecd4c89855f4591bf9d69cc72"
    sha256 cellar: :any,                 sonoma:        "2aa49153277c1f7e17cfb19417c7c1c90b2c1f1f01d2509ef4be49215e9df24c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "144b1e72ec64c79b0ceb3d6a1b8288a82b4a7ad883d2d4e52ba46b18c5f3e0d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "29bb6238dafb1c34d7a82966a929671284df9005d894cb13992777b4e131ba0b"
  end

  depends_on "bdw-gc"

  conflicts_with "v", because: "both install `v` binaries"

  resource "vc" do
    # The vc repo (https://github.com/vlang/vc) contains bootstrapping compiler sources.
    # When updating vlang, find the vc commit whose message matches this release:
    #   [v:master] <vlang commit SHA> - V <version>
    # Then use that vc commit's SHA in the URL below.
    url "https://github.com/vlang/vc/archive/f461dfebcdfac3c75fdf28fec80c07f0a7a9a53d.tar.gz"
    sha256 "f537c63ff195d3583eb2bfdfb51dfc50d8cbaf0ef8b955954cbe4c9a7343d81c"

    on_big_sur :or_older do
      patch do
        url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/vlang/vc.patch"
        sha256 "0e0a2de7e37c0b22690599c0ee0a1176c2c767ea95d5fade009dd9c1f5cbf85d"
      end
    end
  end

  # upstream fix for clang20 + musl qsort signature, https://github.com/vlang/v/issues/24711
  patch do
    url "https://github.com/vlang/v/commit/4333e2ddcb5c5e0927c630bc5c17bdf915a71696.patch?full_index=1"
    sha256 "45fb47de9a17dc391728cc37db2c6409c7ec8915f753179bf9f40eb707451234"
  end

  def install
    # upstream discussion, https://github.com/vlang/v/issues/16776
    inreplace "vlib/builtin/builtin_d_gcboehm.c.v" do |s|
      s.gsub! "#flag -I @VEXEROOT/thirdparty/libgc/include",
              "#flag -I #{Formula["bdw-gc"].opt_include}"
      s.gsub! "$if (prod && !tinyc && !debug) || !(amd64 || arm64 || i386 || arm32 || rv64) {",
              "$if (!macos && prod && !tinyc && !debug) || !(amd64 || arm64 || i386 || arm32 || rv64) {"
      s.gsub! "#flag @VEXEROOT/thirdparty/tcc/lib/libgc.a",
              "#flag #{Formula["bdw-gc"].opt_lib}/libgc.a"
    end

    # upstream-recommended packaging, https://github.com/vlang/v/blob/master/doc/packaging_v_for_distributions.md
    %w[up self].each do |cmd|
      (buildpath/"cmd/tools/v#{cmd}.v").delete
      (buildpath/"cmd/tools/v#{cmd}.v").write <<~EOS
        println('ERROR: `v #{cmd}` is disabled. Use `brew upgrade #{name}` to update V.')
      EOS
    end

    # `v share` requires X11 on Linux, so don't build it
    mv "cmd/tools/vshare.v", "vshare.v.orig" if OS.linux?

    resource("vc").stage do
      system ENV.cc, "-std=c99", "-w", "-o", buildpath/"v1", "v.c", "-lm", "-lpthread"
    end

    bootvfflag = OS.linux? ? ["-cc", ENV.cc] : []
    system "./v1", "-no-parallel", "-o", buildpath/"v2", "-prod", *bootvfflag, "cmd/v"
    system "./v2", "-nocache", "-o", buildpath/"v", "-prod", "-d", "dynamic_boehm", *bootvfflag, "cmd/v"
    rm ["./v1", "./v2"]
    system "./v", "-prod", "-d", "dynamic_boehm", *bootvfflag, "build-tools"
    mv "vshare.v.orig", "cmd/tools/vshare.v" if OS.linux?

    (buildpath/"cmd/tools/.disable_autorecompilation").write ""

    libexec.install "cmd", "thirdparty", "v", "v.mod", "vlib"
    bin.install_symlink libexec/"v"
    pkgshare.install "examples"

    generate_completions_from_executable(bin/"v", "complete", "setup", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    cp pkgshare/"examples/hello_world.v", testpath
    system bin/"v", "-o", "test", "hello_world.v"
    assert_equal "Hello, World!", shell_output("./test").chomp
  end
end
