class S6 < Formula
  desc "Small & secure supervision software suite"
  homepage "https://skarnet.org/software/s6/"
  url "https://skarnet.org/software/s6/s6-2.13.1.0.tar.gz"
  sha256 "bf0614cf52957cb0af04c7b02d10ebd6c5e023c9d46335cbf75484eed3e2ce7e"
  license "ISC"

  livecheck do
    url :homepage
    regex(/href=.*?s6[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7ca0aec1300837db9fbafe96ac0d19d937d5f0173d3476a247e809ff6864927e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7188c224c18347b49f04a91fe303123e681704ef108a262330d036dbe57652eb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f5e99a82c198d22b1a571fb5c422dffd29627bce45b0a9f964a0fcb0cf3ee047"
    sha256 cellar: :any_skip_relocation, sonoma:        "4da05222f6137ef409e26fe0dbf908772c13a68f030fad6d53c273ef0a009534"
    sha256 cellar: :any_skip_relocation, ventura:       "1d903904acbeb5fa6440b6dec1df1d37069ebfda43a52fdc936d47348d7e46f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c1a900e9450e59adf25accb3c767706b80e124a941043124e88cccd552af1ba2"
  end

  resource "skalibs" do
    url "https://skarnet.org/software/skalibs/skalibs-2.14.3.0.tar.gz"
    sha256 "a14aa558c9b09b062fa16acec623b2c8f93d69f5cba4d07f6d0c58913066c427"
  end

  resource "execline" do
    url "https://skarnet.org/software/execline/execline-2.9.6.1.tar.gz"
    sha256 "76919d62f2de4db1ac4b3a59eeb3e0e09b62bcdd9add13ae3f2dad26f8f0e5ca"
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
