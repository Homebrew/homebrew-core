class S6 < Formula
  desc "Small & secure supervision software suite"
  homepage "https://skarnet.org/software/s6/"
  url "https://skarnet.org/software/s6/s6-2.11.2.0.tar.gz"
  sha256 "9fb43690e6018d94733b4dc18cc6926f02454508a4dd86060c9b4b9d20dc8037"
  license "ISC"

  livecheck do
    url :homepage
    regex(/href=.*?s6[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "6791bade06c4fe72cce175c87ed19665cf4c7546aaf8cba2ec825d55298a9997"
    sha256 arm64_monterey: "8040b376f8b7e81456e6cdb3e2ec78ec5efd1000aaa4303c36740502eaf725fb"
    sha256 arm64_big_sur:  "34a66871395e134964e4f20658c37d615d83f2bb23d8ea6b561a71401f2e1bf1"
    sha256 ventura:        "94d2859266a7695e7b3fc46e7f5a415321aff5683dc8e61431eab8fe0a28c233"
    sha256 monterey:       "84aa2c3a0f4529d6a2927dedb2ed32710a6eb1a979b1098150fa779e17ea5c78"
    sha256 big_sur:        "55ded7a207a4db5c804bb966e6f8565f3b3f41160412a98e76441eea28365aef"
    sha256 catalina:       "1a87f90655ae72c9a47421df1b74726224e2a5a715506bbcd103c7925f91a430"
    sha256 x86_64_linux:   "670d1cc52edecdf5f08ff795533cd9b6f2f36c444a91262284e44fd267f17d76"
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
