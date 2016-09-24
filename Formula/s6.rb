class S6 < Formula
  desc "Small & secure supervision software suite."
  homepage "http://skarnet.org/software/s6/"

  stable do
    url "http://skarnet.org/software/s6/s6-2.3.0.0.tar.gz"
    sha256 "49c9a0476d93c6279c776ca5ae9c49b3fd39c356eda674828aebf78f8488e8e6"

    resource "skalibs" do
      url "http://skarnet.org/software/skalibs/skalibs-2.3.10.0.tar.gz"
      sha256 "e4d5147941055b2a367794666f773a4b216c3ae83c015a5fcf2cd0498470ea44"
    end

    resource "execline" do
      url "http://skarnet.org/software/execline/execline-2.1.5.0.tar.gz"
      sha256 "8a3605a6db73183baa376bf2130e8b7eb75a5b5347c7f9144e520fe86bcb1142"
    end
  end

  bottle do
    sha256 "afeaac9d3fca98e1db531cc56ed13e6e48eacc9bbeb383afb184c586edbd07ce" => :el_capitan
    sha256 "e5bcfd0232cf4ab55110bd3f3ec842edc4fa3a5db462c2900f61332268b9da16" => :yosemite
    sha256 "cb4adf9531421b2321c3b1d0a50e388a21f1c1e7bdb38caaa4a7e8158fc0ce72" => :mavericks
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
