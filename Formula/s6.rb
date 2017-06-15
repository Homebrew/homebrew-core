class S6 < Formula
  desc "Small & secure supervision software suite."
  homepage "https://skarnet.org/software/s6/"

  stable do
    url "https://skarnet.org/software/s6/s6-2.6.0.0.tar.gz"
    sha256 "146dd54086063c6ffb6f554c3e92b8b12a24165fdfab24839de811f79dcf9a40"

    resource "skalibs" do
      url "https://skarnet.org/software/skalibs/skalibs-2.5.1.1.tar.gz"
      sha256 "aa387f11a01751b37fd32603fdf9328a979f74f97f0172def1b0ad73b7e8d51d"
    end

    resource "execline" do
      url "https://skarnet.org/software/execline/execline-2.3.0.1.tar.gz"
      sha256 "2bf65aaaf808718952e05c2221b4e9472271e53ebd915c8d1d49a3e992583bf4"
    end
  end

  bottle do
    sha256 "334c8b0dec1a807935fff68558ba92652cf87f09662a6942d108186eb382905b" => :sierra
    sha256 "89113837161737a4854c2cad15bf80d32d53fb7223dd23f50aad58eb65de1961" => :el_capitan
    sha256 "0851bfaaa461210cd2710eef2daf699109a4a1fc317e911d71ea790eb41e823a" => :yosemite
  end

  head do
    url "git://git.skarnet.org/s6"

    resource "skalibs" do
      url "git://git.skarnet.org/skalibs"
    end

    resource "execline" do
      url "git://git.skarnet.org/execline"
    end
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
    bin.env_script_all_files(libexec/"bin", :PATH => "#{libexec}/execline:$PATH")
    sbin.env_script_all_files(libexec/"sbin", :PATH => "#{libexec}/execline:$PATH")
    (bin/"execlineb").write_env_script libexec/"execline/execlineb", :PATH => "#{libexec}/execline:$PATH"
  end

  test do
    # Test execline
    test_script = testpath/"test.eb"
    test_script.write <<-EOS.undent
     import PATH
     if { [ ! -z ${PATH} ] }
       true
    EOS
    system "#{bin}/execlineb", test_script

    # Test s6
    (testpath/"log").mkpath
    pipe_output("#{bin}/s6-log #{testpath}/log", "Test input\n")
    assert_equal "Test input\n", File.read(testpath/"log/current")
  end
end
