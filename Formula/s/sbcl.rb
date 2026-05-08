class Sbcl < Formula
  desc "Steel Bank Common Lisp system"
  homepage "https://www.sbcl.org/"
  url "https://downloads.sourceforge.net/project/sbcl/sbcl/2.6.4/sbcl-2.6.4-source.tar.bz2"
  sha256 "3ba53e654b60feb7c4f50466199d6d5260f2661c711ba22d4b770b655400d57b"
  license all_of: [:public_domain, "MIT", "Xerox", "BSD-3-Clause"]
  compatibility_version 3
  head "https://git.code.sf.net/p/sbcl/sbcl.git", branch: "master"

  livecheck do
    url "https://sourceforge.net/projects/sbcl/rss?path=/sbcl"
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f6529ac84a4f208d31901a5e6d79206b1588e7c4a26a3df307204200db6bbce2"
    sha256 cellar: :any,                 arm64_sequoia: "d8ebb4e20905a029f96624790f6d5f64af9811782378487d9fdf468833a286c7"
    sha256 cellar: :any,                 arm64_sonoma:  "a673de307f9355bd0771756c7f61ebbab3b1da0d61bfca6d029725ba36abdbef"
    sha256 cellar: :any,                 sonoma:        "ea01285ab2b3e5cf744a5baa171414e0468c82aa2ce79b182fbf15ea362521df"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0865be4c76208f38822496fe3d6926444097c44ddfa425d53c834276053b8521"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "88704c013df9d48156712108fa9e6e54b947b7756614740a9bae9aa0c891709c"
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
    (lib/"sbcl/sbclrc").write <<~LISP
      (setf (logical-pathname-translations "SYS")
        '(("SYS:SRC;**;*.*.*" #p"#{pkgshare}/src/**/*.*")
          ("SYS:CONTRIB;**;*.*.*" #p"#{pkgshare}/contrib/**/*.*")))
    LISP
  end

  test do
    (testpath/"simple.sbcl").write <<~LISP
      (write-line (write-to-string (+ 2 2)))
    LISP
    output = shell_output("#{bin}/sbcl --script #{testpath}/simple.sbcl")
    assert_equal "4", output.strip
  end
end
