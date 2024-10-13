class Sbcl < Formula
  desc "Steel Bank Common Lisp system"
  homepage "https://www.sbcl.org/"
  url "https://downloads.sourceforge.net/project/sbcl/sbcl/2.4.9/sbcl-2.4.9-source.tar.bz2"
  sha256 "9970e4ebc5d6943dc64d7ca1f52d9b5cd9fc94cef94d233213d78ec75f3605e2"
  license all_of: [:public_domain, "MIT", "Xerox", "BSD-3-Clause"]
  head "https://git.code.sf.net/p/sbcl/sbcl.git", branch: "master"

  livecheck do
    url "https://sourceforge.net/projects/sbcl/rss?path=/sbcl"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "78b1d9c8492da82823b04f7a302a6804da41017721c4f1610f222728dc39dae8"
    sha256 cellar: :any,                 arm64_sonoma:  "e6da3f10264d10f20e97fc827ed1c18d830ac6834270654aa21f44956a321d61"
    sha256 cellar: :any,                 arm64_ventura: "9c4fd39a2ee00b3601e99d1a8f2e3bd7c7107ff44acfc138feb0f6ccf2ba9ab3"
    sha256 cellar: :any,                 sonoma:        "cae39fcfec3e7f9161beea3f52d06e1702081c480dcface09bafbe82c36340d2"
    sha256 cellar: :any,                 ventura:       "378fd475cad7e97ed0e872ecbddaf05c88845be41a9cf2af1eb3572eeaf0844c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8a2615d1c90b7d2a4e23243405e5e4b7c5fd7616dbfa209c7e51c5521d07a398"
  end

  depends_on "ecl" => :build
  depends_on "zstd"

  def install
    # Remove non-ASCII values from environment as they cause build failures
    # More information: https://bugs.gentoo.org/show_bug.cgi?id=174702
    ENV.delete_if do |_, value|
      ascii_val = value.dup
      ascii_val.force_encoding("ASCII-8BIT") if ascii_val.respond_to? :force_encoding
      ascii_val =~ /[\x80-\xff]/n
    end

    xc_cmdline = "ecl --norc"

    args = [
      "--prefix=#{prefix}",
      "--xc-host=#{xc_cmdline}",
      "--with-sb-core-compression",
      "--with-sb-ldb",
      "--with-sb-thread",
    ]

    ENV["SBCL_MACOSX_VERSION_MIN"] = MacOS.version.to_s if OS.mac?
    system "./make.sh", *args

    ENV["INSTALL_ROOT"] = prefix
    system "sh", "install.sh"

    # Install sources
    bin.env_script_all_files libexec/"bin",
                             SBCL_SOURCE_ROOT: pkgshare/"src",
                             SBCL_HOME:        lib/"sbcl"
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
