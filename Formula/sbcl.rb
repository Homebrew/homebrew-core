class Sbcl < Formula
  desc "Steel Bank Common Lisp system"
  homepage "http://www.sbcl.org/"
  url "https://downloads.sourceforge.net/project/sbcl/sbcl/2.0.3/sbcl-2.0.3-source.tar.bz2"
  sha256 "b5543f123214b2023ff5fc32dfd00b6cfeabd92c8edb33ad208842c4fd642f00"

  bottle do
    sha256 "6a149417139c1362d10c67ae9c2e7d291ceabe34396c0f2c257f8f1835f58124" => :catalina
    sha256 "19a197ed405cae8f2e960b53bf5de11a36a85dba390788f33d4d07e6b6801ad2" => :mojave
    sha256 "b75c6c62b12ff6a8daaaee8115ddece7ff5a4c7827ac2688b598b246f1b2c043" => :high_sierra
  end

  uses_from_macos "zlib"

  # Current binary versions are listed at https://sbcl.sourceforge.io/platform-table.html
  resource "bootstrap64" do
    url "https://downloads.sourceforge.net/project/sbcl/sbcl/1.2.11/sbcl-1.2.11-x86-64-darwin-binary.tar.bz2"
    sha256 "057d3a1c033fb53deee994c0135110636a04f92d2f88919679864214f77d0452"
  end

  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/c5ffdb1118ce0c125c42ab396fa244a7aa01f863/sbcl/patch-make-doc.diff"
    sha256 "7c21c89fd6ec022d4f17670c3253bd33a4ac2784744e4c899c32fbe27203d87e"
  end

  def install
    # Remove non-ASCII values from environment as they cause build failures
    # More information: https://bugs.gentoo.org/show_bug.cgi?id=174702
    ENV.delete_if do |_, value|
      ascii_val = value.dup
      ascii_val.force_encoding("ASCII-8BIT") if ascii_val.respond_to? :force_encoding
      ascii_val =~ /[\x80-\xff]/n
    end

    tmpdir = Pathname.new(Dir.mktmpdir)
    tmpdir.install resource("bootstrap64")

    command = "#{tmpdir}/src/runtime/sbcl"
    core = "#{tmpdir}/output/sbcl.core"
    xc_cmdline = "#{command} --core #{core} --disable-debugger --no-userinit --no-sysinit"

    args = [
      "--prefix=#{prefix}",
      "--xc-host=#{xc_cmdline}",
      "--with-sb-core-compression",
      "--with-sb-ldb",
      "--with-sb-thread",
    ]

    ENV["SBCL_MACOSX_VERSION_MIN"] = MacOS.version
    system "./make.sh", *args

    ENV["INSTALL_ROOT"] = prefix
    system "sh", "install.sh"

    # Install sources
    bin.env_script_all_files libexec/"bin",
                             :SBCL_SOURCE_ROOT => pkgshare/"src",
                             :SBCL_HOME        => lib/"sbcl"
    pkgshare.install %w[contrib src]
    (lib/"sbcl/sbclrc").write <<~EOS
      (setf (logical-pathname-translations "SYS")
        '(("SYS:SRC;**;*.*.*" #p"#{pkgshare}/src/**/*.*")
          ("SYS:CONTRIB;**;*.*.*" #p"#{pkgshare}/contrib/**/*.*")))
    EOS
  end

  test do
    (testpath/"simple.sbcl").write <<~EOS
      (write-line (write-to-string (+ 2 2)))
    EOS
    output = shell_output("#{bin}/sbcl --script #{testpath}/simple.sbcl")
    assert_equal "4", output.strip
  end
end
