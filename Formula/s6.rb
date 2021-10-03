class S6 < Formula
  desc "Small & secure supervision software suite"
  homepage "https://skarnet.org/software/s6/"
  url "https://skarnet.org/software/s6/s6-2.11.0.0.tar.gz"
  sha256 "c545e4e18cd98e7fdbef84566e212276e44630f25de3e7891a3c58e83a9074a8"
  license "ISC"

  livecheck do
    url :homepage
    regex(/href=.*?s6[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "e2ef25cfe9cc6eeb4bb6c44c0b1b887531d582f0a277a60cb912f265198d3247"
    sha256 big_sur:       "ec0bed5bcbfe3a75e9ad5e6d172b1b5f8bf531d46bfe8d00cfefddaf6477c67c"
    sha256 catalina:      "827c8b3861623b6495317ecded680984800b3c6d222da2e613e3da7a02e8a502"
    sha256 mojave:        "bfff5e8f2f1dfb93d87da55e1e1ce1bc8b444e8683f0e861eb7b7dac8952ba42"
    sha256 x86_64_linux:  "917ae23b2f1333cb04ba3c539d4f67f5b72846094dce3aeb37e61c6df34049e0"
  end

  resource "skalibs" do
    url "https://skarnet.org/software/skalibs/skalibs-2.11.0.0.tar.gz"
    sha256 "98dfc8a02a333f5b12d069d84471c0d51ab5a421c4292963048b3652563d34d9"
  end

  resource "execline" do
    url "https://skarnet.org/software/execline/execline-2.8.1.0.tar.gz"
    sha256 "5b55c9f9641e36d4238811ed3ab5586d3a1045cb48e0bda97c9a49fe8bfb5557"
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
