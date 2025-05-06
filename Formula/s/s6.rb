class S6 < Formula
  desc "Small & secure supervision software suite"
  homepage "https://skarnet.org/software/s6/"
  url "https://skarnet.org/software/s6/s6-2.13.2.0.tar.gz"
  sha256 "c5114b8042716bb70691406931acb0e2796d83b41cbfb5c8068dce7a02f99a45"
  license "ISC"

  livecheck do
    url :homepage
    regex(/href=.*?s6[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "67e7b84ebe8f1610f2edeba0bfafb362eb0c6f8fc9bd2e31bbc777ebf384840f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "81cb72f4806fb26f29f6537da49a1c5e7fcccdaa8a8a34d7d878ef3e19e7803c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c59164a75b08590c40b69598f6d846230fe8288de366c5d371f8f7e3d276446a"
    sha256 cellar: :any_skip_relocation, sonoma:        "f282796bae69dd7ccc641601060115edec8bdf4f95889492574725e07eb566c7"
    sha256 cellar: :any_skip_relocation, ventura:       "f985eafa60d7504a2efd641f591189a88467444ccf528a5ef9301ee369bec659"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ec4890a947f1e2aa3363969112a8f80ca3f3bdf647c9ede8fd74a39cb4ec213a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a50281696347be24e9cbfc2a0beb51ad926bdc10bf8efb86b55e57ee3d6afd4c"
  end

  resource "skalibs" do
    url "https://skarnet.org/software/skalibs/skalibs-2.14.4.0.tar.gz"
    sha256 "0e626261848cc920738f92fd50a24c14b21e30306dfed97b8435369f4bae00a5"
  end

  resource "execline" do
    url "https://skarnet.org/software/execline/execline-2.9.7.0.tar.gz"
    sha256 "73c9160efc994078d8ea5480f9161bfd1b3cf0b61f7faab704ab1898517d0207"
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
