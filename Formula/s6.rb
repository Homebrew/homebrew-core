class S6 < Formula
  desc "Small & secure supervision software suite"
  homepage "https://skarnet.org/software/s6/"
  url "https://skarnet.org/software/s6/s6-2.11.3.0.tar.gz"
  sha256 "0ef2de80c40b603d58bf65ec5dd9f0bb1f227d35f311e8948d9e30f81efb5b81"
  license "ISC"

  livecheck do
    url :homepage
    regex(/href=.*?s6[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "9036deb01a38925a5a2224617aba7215b7e2bd090c604e7fffb19664a1496a01"
    sha256 arm64_monterey: "f30edaca6c99ca5375595ccb9aed3ad15a453ddea2e26d6240af305df521ad60"
    sha256 arm64_big_sur:  "267b0c2cd212a38eb8e166c4d60759a3701d8276f7624d5adaa9c4b086f11d7a"
    sha256 ventura:        "db1053bd3a19a232999a4d51d34c60594cf7932bb4dfe918b28d8631d3f1ddc7"
    sha256 monterey:       "c169933c1a6903f900295b4b7993762df24a63f2ab73129200a7de415b18faef"
    sha256 big_sur:        "9eef22c17e62fcad2a02830dd15d395ef89966ebbbd68e6be41489170f6449dd"
    sha256 x86_64_linux:   "1ddcba8807707b9221dd242f72b3d72ef6fa8f5a5e66d938dc7a1166f65ba995"
  end

  resource "skalibs" do
    url "https://skarnet.org/software/skalibs/skalibs-2.13.0.0.tar.gz"
    sha256 "b875bf3df3f0f500984ccafe45a9a95add7e4026b39ee8da620f09606be74fcc"
  end

  resource "execline" do
    url "https://skarnet.org/software/execline/execline-2.9.1.0.tar.gz"
    sha256 "b5d68e021fa0c4679089d265110a6c81f4ecc141067bf686dccb4bfd061c0404"
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
