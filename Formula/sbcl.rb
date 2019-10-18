class Sbcl < Formula
  desc "Steel Bank Common Lisp system"
  homepage "http://www.sbcl.org/"
  url "https://downloads.sourceforge.net/project/sbcl/sbcl/1.5.7/sbcl-1.5.7-source.tar.bz2"
  sha256 "54742fb5e2f3f350fbafd72bc73662fca21382b5553ed6a146098950d2409485"
  revision 1

  bottle do
    sha256 "768b97a7b45d987a9880348e105a5134b2d1babc1e1048c4139820a93e27ceda" => :catalina
    sha256 "7e75877ee61c8818ca836967c1df526b4c8126773e7d836a3e868800ba559fdf" => :mojave
    sha256 "094b689bc00f692fcd90ea879b414a3bda0f2b0784463b459c11699038932a25" => :high_sierra
  end

  # Current binary versions are listed at https://sbcl.sourceforge.io/platform-table.html
  resource "bootstrap64" do
    url "https://downloads.sourceforge.net/project/sbcl/sbcl/1.2.11/sbcl-1.2.11-x86-64-darwin-binary.tar.bz2"
    sha256 "057d3a1c033fb53deee994c0135110636a04f92d2f88919679864214f77d0452"
  end

  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/c5ffdb11/sbcl/patch-make-doc.diff"
    sha256 "7c21c89fd6ec022d4f17670c3253bd33a4ac2784744e4c899c32fbe27203d87e"
  end

  # Two patches below prevent a segfault on macOS Catalina
  patch :p1 do
    url "https://github.com/sbcl/sbcl/commit/07d135b0dd4e7c34bc0dce6aac07570d66e297ee.diff?full_index=1"
    sha256 "7522320e325451a61181edfd0a3ccbd21b48850102c0f976c9af814117a8b29e"
  end

  patch :p1 do
    url "https://github.com/sbcl/sbcl/commit/5cefb8506b7d8d9a0277236eb3f7e76c4428ac10.diff?full_index=1"
    sha256 "e88cec2d4e8d9eff9658a7706ac25718d5d8cd09df3928692f2b27e0644dd73c"
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
    bin.env_script_all_files(libexec/"bin", :SBCL_SOURCE_ROOT => pkgshare/"src")
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
