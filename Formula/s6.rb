class S6 < Formula
  desc "Small & secure supervision software suite."
  homepage "https://skarnet.org/software/s6/"

  stable do
    url "https://skarnet.org/software/s6/s6-2.6.1.0.tar.gz"
    sha256 "f0de303791134302f2630b9fe76a936b064e1e3aa772c8ae1b891155a6ea2c79"

    resource "skalibs" do
      url "https://skarnet.org/software/skalibs/skalibs-2.6.0.0.tar.gz"
      sha256 "3572cb8c7d2ae9d16da5a0f3d23b48e013e0c957f1329d100f04dd5accb054c3"
    end

    resource "execline" do
      url "https://skarnet.org/software/execline/execline-2.3.0.2.tar.gz"
      sha256 "c11650651a7230bd5687945a7698b2da3fe13c3c0eb15e296bb91769d4775f45"
    end
  end

  bottle do
    sha256 "055a227b16fdaf33cdf43442f3d17c9574bd0896e67607b666d27ff97b3c966b" => :sierra
    sha256 "22e5fb903bacda03540bcb1233a0c0d4f22067acb7a8c1e48f01fbc0f070e844" => :el_capitan
    sha256 "966fdf4c2149c8c74ad728606c9c0b6517aca72a7d751b07727f5dd13dafe723" => :yosemite
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
