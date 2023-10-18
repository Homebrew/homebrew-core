class S6 < Formula
  desc "Small & secure supervision software suite"
  homepage "https://skarnet.org/software/s6/"
  url "https://skarnet.org/software/s6/s6-2.11.3.2.tar.gz"
  sha256 "7c16138ad2f0ffbe0ed2ae8dd0cecada9f7c787edd33a69084d219110693df74"
  license "ISC"

  livecheck do
    url :homepage
    regex(/href=.*?s6[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "dc7a7fa30e7e862c933c945d61c50832da0fdd5a4a9a0d1bed0691f4bbff0cf7"
    sha256 arm64_ventura:  "7d82841a937d225abe30cb936f17b0dfaa9b55b44664d0c078947b3e2f31b842"
    sha256 arm64_monterey: "a2a9990dd6bad436267683f63064852bdd0b1601cfdd0d5b0bf4950692b70afe"
    sha256 arm64_big_sur:  "f0faec1206b628932b008704bd06afe90ee619c5f16cc12028ad13e6f42899b8"
    sha256 sonoma:         "800455731adf63c901b0de94005f6ec0e57c36949eb20c2f8fe4e39d6c4dd072"
    sha256 ventura:        "f889869c9aad0692f722d521d8272c18bc524afbdf1649f663a0e41812d4ecc3"
    sha256 monterey:       "22afe8784431c63955c9effd899e11c8dd293ce335ca739b3752e188585c7396"
    sha256 big_sur:        "d06ef0c95d2805357b0c2b9185c3d9deaf4f6f364e08debe099665f0877f0f71"
    sha256 x86_64_linux:   "9481a027a93de16c244988d29f55b41c7a098b2c5ba634afcf11615cb50d0acb"
  end

  resource "skalibs" do
    url "https://skarnet.org/software/skalibs/skalibs-2.13.1.1.tar.gz"
    sha256 "b272a1ab799f7fac44b9b4fb5ace78a9616b2fe4882159754b8088c4d8199e33"
  end

  resource "execline" do
    url "https://skarnet.org/software/execline/execline-2.9.3.0.tar.gz"
    sha256 "c8027fa70922d117cdee8cc20d277e38d03fd960e6d136d8cec32603d4ec238d"
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
