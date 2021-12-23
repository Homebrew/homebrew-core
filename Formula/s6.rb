class S6 < Formula
  desc "Small & secure supervision software suite"
  homepage "https://skarnet.org/software/s6/"
  url "https://skarnet.org/software/s6/s6-2.11.0.1.tar.gz"
  sha256 "ad7f204587634eeb20ef8f7a7beb6dd63ba3080a46a3a650448ca7cc0826f90a"
  license "ISC"

  livecheck do
    url :homepage
    regex(/href=.*?s6[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "d193d759ad97033b030e533f55cb9c840758f742808e55572c9473e965a4d1b2"
    sha256 arm64_big_sur:  "fd63c8dd93429cdc9930b8c3af149b2eb948d93cab5a7e0735971c6bcc3afad2"
    sha256 monterey:       "8ed4a400a9686baf025c5405aeb3b9fe36fbe257c4bdc26edf2c8beb3524291b"
    sha256 big_sur:        "4d18fc8a563361bdb4cac4b421256e8fa2badb01c82b0692fcddb7d477ed360a"
    sha256 catalina:       "6b651eb8e448c4a97f3446ea3116a8ef7933b28f57d698b3f24bc92e558791a2"
    sha256 mojave:         "cdc4ffac93485352efffc1e169f9d1576d52b06afc65b8ea6bbb7f313f69b860"
    sha256 x86_64_linux:   "09b1f7acbbbcf942f5126ab84cdff586e869a68b3d9a1496cc2aed1af5e07c7c"
  end

  resource "skalibs" do
    url "https://skarnet.org/software/skalibs/skalibs-2.11.1.0.tar.gz"
    sha256 "400180b4d5b651e4fafaf0297b933f5f863b467d357f5b36a6545cf6eb14eab9"
  end

  resource "execline" do
    url "https://skarnet.org/software/execline/execline-2.8.2.0.tar.gz"
    sha256 "2fdf7607f306e94fe42ebe2b49872d0f654aa2297a576d5a2d8037d4d9583341"
  end

  def install
    resources.each { |r| r.stage(buildpath/r.name) }
    build_dir = buildpath/"build"

    cd "skalibs" do
      system "./configure", "--disable-shared", "--prefix=#{build_dir}", "--libdir=#{build_dir}/lib"
      system "make", "install"
    end

    cd "execline" do
      system "./configure",
        "--prefix=#{build_dir}",
        "--bindir=#{libexec}/execline",
        "--with-include=#{build_dir}/include",
        "--with-lib=#{build_dir}/lib",
        "--with-sysdeps=#{build_dir}/lib/skalibs/sysdeps",
        "--disable-shared"
      system "make", "install"
    end

    system "./configure",
      "--prefix=#{prefix}",
      "--libdir=#{build_dir}/lib",
      "--includedir=#{build_dir}/include",
      "--with-include=#{build_dir}/include",
      "--with-lib=#{build_dir}/lib",
      "--with-lib=#{build_dir}/lib/execline",
      "--with-sysdeps=#{build_dir}/lib/skalibs/sysdeps",
      "--disable-static",
      "--disable-shared"
    system "make", "install"

    # Some S6 tools expect execline binaries to be on the path
    bin.env_script_all_files(libexec/"bin", PATH: "#{libexec}/execline:$PATH")
    sbin.env_script_all_files(libexec/"sbin", PATH: "#{libexec}/execline:$PATH")
    (bin/"execlineb").write_env_script libexec/"execline/execlineb", PATH: "#{libexec}/execline:$PATH"
    doc.install Dir["doc/*"]
  end

  test do
    (testpath/"test.eb").write <<~EOS
      foreground
      {
        sleep 1
      }
      "echo"
      "Homebrew"
    EOS
    assert_match "Homebrew", shell_output("#{bin}/execlineb test.eb")

    (testpath/"log").mkpath
    pipe_output("#{bin}/s6-log #{testpath}/log", "Test input\n", 0)
    assert_equal "Test input\n", File.read(testpath/"log/current")
  end
end
